//! jud — lanzador interactivo de Claude Code.
//!
//! Dibuja un selector inline (cuenta, modelo, esfuerzo, permisos) con el
//! mascota de Claude Code animado y, al confirmar, reemplaza el proceso con
//! `claude` vía exec(2): no queda ningún proceso intermedio.

use std::{
    env, fs,
    os::unix::process::CommandExt,
    path::PathBuf,
    process::{exit, Command},
    time::{Duration, Instant},
};

use ratatui::{
    crossterm::event::{self, Event, KeyCode, KeyEventKind, KeyModifiers},
    layout::Rect,
    style::{Color, Modifier, Style},
    text::{Line, Span},
    widgets::Paragraph,
    Frame, TerminalOptions, Viewport,
};

const HEIGHT: u16 = 12;
const FPS: u64 = 30;

struct Account {
    name: &'static str,
    /// Relativo a $HOME; `None` es la configuración por defecto (~/.claude).
    dir: Option<&'static str>,
    tint: Rgb,
}

const ACCOUNTS: [Account; 2] = [
    Account { name: "personal", dir: None, tint: (217, 119, 87) },
    Account { name: "trabajo", dir: Some(".claude-trabajo"), tint: (110, 158, 222) },
];
const MODELS: [&str; 4] = ["fable", "opus", "sonnet", "haiku"];
const EFFORTS: [&str; 5] = ["low", "medium", "high", "xhigh", "max"];
const PERMS: [&str; 2] = ["bypass", "normal"];
const LABELS: [&str; 4] = ["cuenta", "modelo", "esfuerzo", "permisos"];
/// Frecuencia (Hz) de la "respiración" del mascota según el esfuerzo.
const BREATH_HZ: [f64; 5] = [0.25, 0.4, 0.6, 0.95, 1.6];

const MASCOT: [&str; 3] = [" ▐▛███▜▌", "▝▜█████▛▘", "  ▘▘ ▝▝"];
const MASCOT_BLINK: &str = " ▐█████▌";

const DIM: Color = Color::Rgb(98, 98, 104);
const MID: Color = Color::Rgb(150, 150, 156);
const HI: Color = Color::Rgb(232, 232, 236);

type Rgb = (u8, u8, u8);

fn mix(a: Rgb, b: Rgb, t: f64) -> Rgb {
    let l = |x: u8, y: u8| (x as f64 + (y as f64 - x as f64) * t.clamp(0.0, 1.0)).round() as u8;
    (l(a.0, b.0), l(a.1, b.1), l(a.2, b.2))
}

fn rgb(c: Rgb) -> Color {
    Color::Rgb(c.0, c.1, c.2)
}

fn options(row: usize) -> Vec<&'static str> {
    match row {
        0 => ACCOUNTS.iter().map(|a| a.name).collect(),
        1 => MODELS.to_vec(),
        2 => EFFORTS.to_vec(),
        _ => PERMS.to_vec(),
    }
}

fn home() -> PathBuf {
    env::var_os("HOME").map(PathBuf::from).unwrap_or_default()
}

fn state_file() -> PathBuf {
    home().join(".config/jud/last")
}

/// Email de la sesión iniciada en cada cuenta, leído de su `.claude.json`.
fn account_email(acc: &Account) -> String {
    let path = match acc.dir {
        Some(d) => home().join(d).join(".claude.json"),
        None => home().join(".claude.json"),
    };
    fs::read_to_string(path)
        .ok()
        .and_then(|s| serde_json::from_str::<serde_json::Value>(&s).ok())
        .and_then(|v| v["oauthAccount"]["emailAddress"].as_str().map(String::from))
        .unwrap_or_else(|| "sin sesión".into())
}

fn tilde(p: &str) -> String {
    let h = home();
    let h = h.to_string_lossy();
    match p.strip_prefix(h.as_ref()) {
        Some(rest) if !h.is_empty() => format!("~{rest}"),
        _ => p.to_string(),
    }
}

/// Modelo, esfuerzo y permisos (índices) de una cuenta.
type Prefs = [usize; 3];

/// Por defecto: opus · high · bypass
const DEFAULT_PREFS: Prefs = [1, 2, 0];

/// Lee el estado guardado:
///
/// ```text
/// last trabajo
/// personal opus high bypass
/// trabajo sonnet medium bypass
/// ```
///
/// Devuelve la última cuenta usada y las preferencias de cada una.
fn load_state() -> (usize, [Prefs; ACCOUNTS.len()]) {
    let mut last = None;
    let mut prefs = [DEFAULT_PREFS; ACCOUNTS.len()];
    let text = fs::read_to_string(state_file()).unwrap_or_default();
    for line in text.lines() {
        let words: Vec<&str> = line.split_whitespace().collect();
        let Some((&head, rest)) = words.split_first() else { continue };
        let find = |name: &str| ACCOUNTS.iter().position(|a| a.name == name);
        if head == "last" {
            last = rest.first().and_then(|w| find(w)).or(last);
        } else if let Some(acc) = find(head) {
            for (i, word) in rest.iter().take(3).enumerate() {
                if let Some(v) = options(i + 1).iter().position(|o| o == word) {
                    prefs[acc][i] = v;
                }
            }
            // Formato antiguo de una sola línea: la cuenta que aparece es la última.
            last = last.or(Some(acc));
        }
    }
    (last.unwrap_or(0), prefs)
}

fn save_state(last: usize, prefs: &[Prefs]) {
    let mut out = format!("last {}\n", ACCOUNTS[last].name);
    for (acc, p) in ACCOUNTS.iter().zip(prefs) {
        let words: Vec<&str> = (0..3).map(|i| options(i + 1)[p[i]]).collect();
        out.push_str(&format!("{} {}\n", acc.name, words.join(" ")));
    }
    if let Some(dir) = state_file().parent() {
        let _ = fs::create_dir_all(dir);
    }
    let _ = fs::write(state_file(), out);
}

struct App {
    /// Selección visible: cuenta, modelo, esfuerzo, permisos.
    sel: [usize; 4],
    /// Preferencias de cada cuenta; la de la cuenta activa vive en `sel[1..]`.
    prefs: [Prefs; ACCOUNTS.len()],
    row: usize,
    emails: Vec<String>,
    cwd: String,
    start: Instant,
    phase: f64,
    color: (f64, f64, f64),
    hop_until: Instant,
    launching: Option<Instant>,
}

impl App {
    fn new() -> Self {
        let (last, prefs) = load_state();
        let [m, e, p] = prefs[last];
        let sel = [last, m, e, p];
        let tint = ACCOUNTS[last].tint;
        let now = Instant::now();
        App {
            sel,
            prefs,
            row: 0,
            emails: ACCOUNTS.iter().map(account_email).collect(),
            cwd: env::current_dir().map(|p| tilde(&p.to_string_lossy())).unwrap_or_default(),
            start: now,
            phase: 0.0,
            color: (tint.0 as f64, tint.1 as f64, tint.2 as f64),
            hop_until: now,
            launching: None,
        }
    }

    fn account(&self) -> &'static Account {
        &ACCOUNTS[self.sel[0]]
    }

    fn shift(&mut self, delta: isize) {
        let n = options(self.row).len() as isize;
        let next = (self.sel[self.row] as isize + delta).rem_euclid(n) as usize;
        if next == self.sel[self.row] {
            return;
        }
        if self.row == 0 {
            // Al cambiar de cuenta, guarda lo elegido y carga lo de la otra.
            self.prefs[self.sel[0]] = self.current_prefs();
            let [m, e, p] = self.prefs[next];
            self.sel = [next, m, e, p];
        } else {
            self.sel[self.row] = next;
        }
        self.hop_until = Instant::now() + Duration::from_millis(170);
    }

    fn current_prefs(&self) -> Prefs {
        [self.sel[1], self.sel[2], self.sel[3]]
    }

    fn tick(&mut self, dt: f64) {
        self.phase += dt * BREATH_HZ[self.sel[2]] * std::f64::consts::TAU;
        // El color se desliza hacia el tinte de la cuenta en vez de saltar.
        let t = self.account().tint;
        let k = 1.0 - (-dt * 9.0).exp();
        self.color.0 += (t.0 as f64 - self.color.0) * k;
        self.color.1 += (t.1 as f64 - self.color.1) * k;
        self.color.2 += (t.2 as f64 - self.color.2) * k;
    }

    fn tint(&self) -> Rgb {
        (self.color.0 as u8, self.color.1 as u8, self.color.2 as u8)
    }

    fn args(&self) -> Vec<String> {
        let mut a = vec![
            "--model".into(),
            MODELS[self.sel[1]].into(),
            "--effort".into(),
            EFFORTS[self.sel[2]].into(),
        ];
        if self.sel[3] == 0 {
            a.push("--dangerously-skip-permissions".into());
        }
        a
    }

    fn draw(&self, f: &mut Frame, extra: &[String]) {
        let area = f.area();
        let put = |f: &mut Frame, x: u16, y: u16, line: Line| {
            if y < area.height && x < area.width {
                let r = Rect::new(area.x + x, area.y + y, area.width - x, 1);
                f.render_widget(Paragraph::new(line), r);
            }
        };

        let t = self.start.elapsed().as_secs_f64();
        let tint = self.tint();
        let breath = (self.phase.sin() + 1.0) / 2.0;
        let body = rgb(mix(tint, (255, 236, 220), breath * 0.28));
        let accent = Style::new().fg(rgb(tint)).add_modifier(Modifier::BOLD);

        // Mascota: parpadea cada ~3.7 s y da un saltito al cambiar de opción.
        let blink = t % 3.7 < 0.13 || (t % 11.0 > 0.25 && t % 11.0 < 0.36);
        let top = if Instant::now() < self.hop_until { 0 } else { 1 };
        for (i, row) in MASCOT.iter().enumerate() {
            let s: &str = if i == 0 && blink { MASCOT_BLINK } else { row };
            put(f, 3, top + i as u16, Line::styled(s, Style::new().fg(body)));
        }
        if let Some(t0) = self.launching {
            let k = t0.elapsed().as_millis();
            let spark = Style::new().fg(rgb(mix(tint, (255, 255, 255), 0.5)));
            if k > 40 { put(f, 1, 0, Line::styled("✻", spark)); }
            if k > 120 { put(f, 12, 1, Line::styled("✻", spark)); }
            if k > 200 { put(f, 0, 3, Line::styled("·", spark)); }
        }

        // Título con un brillo que recorre las letras.
        let title = "Claude Code";
        let n = title.chars().count() as f64;
        let pos = (t * 7.0) % (n + 18.0) - 4.0;
        let spans: Vec<Span> = title
            .chars()
            .enumerate()
            .map(|(i, c)| {
                let d = (i as f64 - pos).abs();
                let glow = (1.0 - d / 2.5).max(0.0);
                let c_rgb = mix(mix(tint, (235, 235, 240), 0.35), (255, 255, 255), glow);
                Span::styled(c.to_string(), Style::new().fg(rgb(c_rgb)).add_modifier(Modifier::BOLD))
            })
            .collect();
        let mut head = Line::from(spans);
        if self.launching.is_some() {
            head.push_span(Span::styled("  lanzando…", Style::new().fg(MID).add_modifier(Modifier::ITALIC)));
        }
        put(f, 15, 1, head);
        put(f, 15, 2, Line::styled(self.emails[self.sel[0]].clone(), Style::new().fg(MID)));
        put(f, 15, 3, Line::styled(self.cwd.clone(), Style::new().fg(DIM)));

        // Selectores
        for row in 0..4 {
            let focused = row == self.row;
            let mut spans = vec![
                Span::styled(if focused { "  › " } else { "    " }, accent),
                Span::styled(
                    format!("{:<10}", LABELS[row]),
                    if focused { Style::new().fg(HI) } else { Style::new().fg(DIM) },
                ),
            ];
            for (i, opt) in options(row).iter().enumerate() {
                let style = if i == self.sel[row] {
                    accent
                } else if focused {
                    Style::new().fg(MID)
                } else {
                    Style::new().fg(DIM)
                };
                spans.push(Span::styled(*opt, style));
                spans.push(Span::raw("   "));
            }
            put(f, 0, 5 + row as u16, Line::from(spans));
        }

        // Comando que se va a ejecutar
        let mut cmd = String::from("$ ");
        if let Some(d) = self.account().dir {
            cmd.push_str(&format!("CLAUDE_CONFIG_DIR=~/{d} "));
        }
        cmd.push_str("claude ");
        cmd.push_str(&self.args().join(" "));
        for a in extra {
            cmd.push(' ');
            cmd.push_str(a);
        }
        put(f, 4, 10, Line::styled(cmd, Style::new().fg(DIM)));

        let key = Style::new().fg(MID);
        let txt = Style::new().fg(DIM);
        put(
            f,
            4,
            11,
            Line::from(vec![
                Span::styled("↵", key), Span::styled(" lanzar   ", txt),
                Span::styled("←→", key), Span::styled(" elegir   ", txt),
                Span::styled("↑↓", key), Span::styled(" mover   ", txt),
                Span::styled("esc", key), Span::styled(" salir", txt),
            ]),
        );
    }
}

fn main() {
    // Todo lo que venga después de `jud` se pasa tal cual a claude (p. ej. `jud -c`).
    let extra: Vec<String> = env::args().skip(1).collect();
    let mut app = App::new();

    let mut terminal = ratatui::init_with_options(TerminalOptions { viewport: Viewport::Inline(HEIGHT) });
    let frame = Duration::from_millis(1000 / FPS);
    let mut last = Instant::now();

    let launch = loop {
        let now = Instant::now();
        app.tick((now - last).as_secs_f64());
        last = now;
        if terminal.draw(|f| app.draw(f, &extra)).is_err() {
            break false;
        }
        if let Some(t0) = app.launching {
            if t0.elapsed() > Duration::from_millis(300) {
                break true;
            }
        }
        if !event::poll(frame).unwrap_or(false) {
            continue;
        }
        let Ok(Event::Key(k)) = event::read() else { continue };
        if k.kind != KeyEventKind::Press || app.launching.is_some() {
            continue;
        }
        match k.code {
            KeyCode::Esc | KeyCode::Char('q') => break false,
            KeyCode::Char('c') if k.modifiers.contains(KeyModifiers::CONTROL) => break false,
            KeyCode::Enter => app.launching = Some(Instant::now()),
            KeyCode::Up | KeyCode::Char('k') | KeyCode::BackTab => app.row = (app.row + 3) % 4,
            KeyCode::Down | KeyCode::Char('j') | KeyCode::Tab => app.row = (app.row + 1) % 4,
            KeyCode::Left | KeyCode::Char('h') => app.shift(-1),
            KeyCode::Right | KeyCode::Char('l') => app.shift(1),
            _ => {}
        }
    };

    // Borra el área inline para no dejar basura en el scrollback.
    let _ = terminal.clear();
    ratatui::restore();

    if !launch {
        exit(130);
    }

    app.prefs[app.sel[0]] = app.current_prefs();
    save_state(app.sel[0], &app.prefs);
    let words: Vec<&str> = (0..4).map(|r| options(r)[app.sel[r]]).collect();

    let tint = rgb(app.account().tint);
    if let Color::Rgb(r, g, b) = tint {
        println!("\x1b[38;2;{r};{g};{b}m✻\x1b[0m \x1b[2m{}\x1b[0m", words[..3].join(" · "));
    }

    let mut cmd = Command::new("claude");
    match app.account().dir {
        Some(d) => cmd.env("CLAUDE_CONFIG_DIR", home().join(d)),
        None => cmd.env_remove("CLAUDE_CONFIG_DIR"),
    };
    let err = cmd.args(app.args()).args(&extra).exec();
    eprintln!("jud: no pude ejecutar claude: {err}");
    exit(127);
}
