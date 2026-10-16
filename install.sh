#!/bin/bash

SRC_DIR="$(pwd)"

TARGET_FILES=(
  ".vimrc"
  ".vim"
  ".editrc"
  ".inputrc"
  ".fdignore"
  ".rgignore"
  ".config/nvim-minimal"
  ".config/nvim"
  ".config/fish"
  ".config/ghostty"
)

for dotfile in "${TARGET_FILES[@]}"; do
  rm -rf "${HOME}/${dotfile}"
  # En una máquina nueva ~/.config todavía no existe
  mkdir -p "$(dirname "${HOME}/${dotfile}")"
  ln -svf "${SRC_DIR}/${dotfile}" "${HOME}/${dotfile}"
done

# jud: lanzador de Claude Code (Rust). Se compila desde el código del repo
# porque el binario no se versiona; queda en ~/.local/bin (en el PATH vía config.fish).
if command -v cargo >/dev/null 2>&1; then
  echo "Compilando jud..."
  cargo install --quiet --locked --force --path "${SRC_DIR}/jud" --root "${HOME}/.local" \
    && rm -f "${HOME}/.local/.crates.toml" "${HOME}/.local/.crates2.json" \
    && echo "jud instalado en ${HOME}/.local/bin/jud"
else
  echo "AVISO: no hay cargo; jud no se instaló." >&2
  echo "       Instala Rust (brew install rustup && rustup-init -y) y vuelve a correr install.sh." >&2
fi
