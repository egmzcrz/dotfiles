#!/bin/bash

SRC_DIR="$(pwd)"

TARGET_FILES=(
	".vimrc"
	".editrc"
	".fdignore"
	".config/nvim-minimal"
	".config/nvim"
	".config/kitty"
	".config/fish"
	".config/doom"
	".config/vifm"
)

for dotfile in "${TARGET_FILES[@]}";do
	rm -rf "${HOME}/${dotfile}"
	ln -svf "${SRC_DIR}/${dotfile}" "${HOME}/${dotfile}"
done
