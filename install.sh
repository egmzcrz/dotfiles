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
