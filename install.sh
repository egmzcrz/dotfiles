#!/bin/bash

SRC_DIR="$(pwd)"

TARGET_FILES=(
	".vimrc"
	".editrc"
	".ignore"
	".fdignore"
	".config/nvim-minimal"
	".config/nvim"
	".config/kitty"
	".config/fish"
	".config/doom"
)

for dotfile in "${TARGET_FILES[@]}";do
	rm -rf "${HOME}/${dotfile}"
	ln -svf "${SRC_DIR}/${dotfile}" "${HOME}/${dotfile}"
done
