#!/bin/bash

SRC_DIR="$(pwd)"

TARGET_FILES=(
	".vimrc"
	".vim"
	".editrc"
	".inputrc"
	".fdignore"
	".config/nvim-minimal"
	".config/nvim"
	".config/fish"
	".config/doom"
	".config/vifm"
	".config/kitty"
	".config/ghostty"
	".config/wezterm"
)

for dotfile in "${TARGET_FILES[@]}";do
	rm -rf "${HOME}/${dotfile}"
	ln -svf "${SRC_DIR}/${dotfile}" "${HOME}/${dotfile}"
done
