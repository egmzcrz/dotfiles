############################################################
#                 Vim + Emacs keybindings                  #
############################################################
set --global fish_key_bindings fish_hybrid_key_bindings

############################################################
#                 FZF (PatrickF1/fzf.fish)                 #
############################################################
# To install keybindings and fuzzy completion: /opt/homebrew/opt/fzf/install
bind -M insert ç fzf-cd-widget # to use ALT-C properly on MAC-OS
# FZF defaults
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --exclude node_modules . \$dir"
set -gx FZF_DEFAULT_OPTS "--height 99% --layout=reverse --border --preview-window down:15 --preview 'bat --color=always {}'"
# CTRL-T command
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
# ALT-C command
set -gx FZF_ALT_C_COMMAND "fd --type d --follow --exclude .git --exclude node_modules . \$dir"
set -gx FZF_ALT_C_OPTS "--preview 'lsd --group-directories-first --long --header {}'"
# CTRL-R command
set -gx FZF_CTRL_R_OPTS "
--preview 'echo {}' --preview-window up:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'"

############################################################
#                  Nvim as default editor                  #
############################################################
set -gx EDITOR nvim
set -gx VISUAL nvim

############################################################
#                       ABBR/ALIAS                         #
############################################################
# source this config file
abbr so 'source ~/.config/fish/config.fish'
# Java home
abbr java11 'set -x JAVA_HOME (/usr/libexec/java_home -v11)'
abbr java17 'set -x JAVA_HOME (/usr/libexec/java_home -v17)'
abbr java21 'set -x JAVA_HOME (/usr/libexec/java_home -v21)'
abbr java22 'set -x JAVA_HOME (/usr/libexec/java_home -v22)'
abbr java23 'set -x JAVA_HOME (/usr/libexec/java_home -v23)'
abbr java26 'set -x JAVA_HOME (/usr/libexec/java_home -v26)'
# nvim minimal
abbr vim 'nvim --clean -u ~/.config/nvim-minimal/init.lua'
# python3
abbr python python3
# julia pluto
abbr pluto 'julia -e "import Pluto; Pluto.run()"'
# R
abbr R 'R --no-save'
# LSD
abbr ll 'lsd --header --long --group-directories-first'
abbr ls lsd
# config files
abbr dotfiles 'cd ~/dotfiles/ && nvim .'
abbr nvimrc 'cd ~/.config/nvim/ && nvim .'
abbr vimrc 'vim ~/.config/nvim-minimal/init.lua'
abbr fishrc 'nvim ~/.config/fish/config.fish'
abbr kittyrc 'nvim ~/.config/kitty/kitty.conf'
# quick access
set CLOUD GDrive
abbr cl "cd ~/GDrive && lsd --header --long --group-directories-first"
abbr bin "cd ~/GDrive/dev/scripts/"
abbr down "cd ~/Downloads/"
abbr dow "cd ~/Downloads/"
abbr docs "cd ~/Documents/"
abbr doc "cd ~/Documents/"
abbr desk "cd ~/Desktop/"
abbr note "cd ~/GDrive/notas/trabajo/"
abbr notas "cd ~/GDrive/notas/trabajo/"
abbr nota "cd ~/GDrive/notas/trabajo/"
# utils
abbr duh "du -ah . | sort -k1,1 -h | tail"
# concat images
abbr hcat convert +append
abbr vcat convert -append
# long2wide script
abbr long2wide "python ~/$CLOUD/dev/scripts/long2wide.py"
# Bulk rename inside VIM
abbr rename "qmv -f do"
# Pandoc
abbr pandoc "pandoc --template=eisvogel.latex -s -f markdown"
# Claude Code
abbr claude "claude --dangerously-skip-permissions"

# Fuzzy find word and edit file
function fw
    # Performance: skip large files and binary blobs to keep rg fast
    set -l rg_opts \
        --line-number --no-heading --color=always --smart-case \
        --max-filesize 1M \
        --glob '!node_modules' \
        --glob '!.git' \
        --glob '!*.{jpg,jpeg,png,gif,ico,svg,webp,pdf,tar,gz,bz2,xz,7z,zip,mp4,mov,avi,mkv,mp3,wav,flac,ogg,ttf,woff,woff2,eot,otf,wasm,o,a,so,dylib,class,pyc,lock,bin,dat,db,sqlite}'

    # Build the search pattern: use the argument if given, otherwise match everything
    if set -q argv[1]
        set -l pattern "$argv[1]"
    else
        set -l pattern .
    end

    set result (rg $rg_opts "$pattern" \
        | fzf --ansi \
            --delimiter ':' -n 2.. \
            --preview-window ~8,+{2}-5 \
            --preview "bat --color=always {1} --highlight-line {2}" \
            --bind ctrl-k:preview-up,ctrl-j:preview-down \
            --bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down)

    if test -n "$result"
        set filepath (echo $result | awk -F':' '{print $1}')
        set linenumber (echo $result | awk -F':' '{print $2}')
        nvim +$linenumber $filepath
    end
end

# Fuzzy find file and cd to parent dir
function ff
    set path (fzf)
    if test -n "$path"
        cd $(dirname $path)
    end
end

function boxshell
    if set -q argv[2]
        echo $argv[1] | boxes -d shell -a hc -s $argv[2]
    else
        echo $argv[1] | boxes -d shell -a hc
    end
end

function boxtex
    if set -q argv[2]
        echo $argv[1] | boxes -d tex-box -a hc -s $argv[2]
    else
        echo $argv[1] | boxes -d tex-box -a hc
    end
end

function boxcpp
    if set -q argv[2]
        echo $argv[1] | boxes -d jstone -a hc -s $argv[2]
    else
        echo $argv[1] | boxes -d jstone -a hc
    end
end

# zip without MAC-OS junk
function zipper
    set filename (basename $argv[1])
    zip -x \*.DS_Store -x \*__MACOSX -r $filename.zip $argv[1]
end

# init commands
starship init fish | source
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/venv-main/bin/activate.fish
