############################################################
#                 Vim + Emacs keybindings                  #
############################################################
fish_hybrid_key_bindings

############################################################
#                 FZF (PatrickF1/fzf.fish)                 #
############################################################
# To install keybindings and fuzzy completion: /opt/homebrew/opt/fzf/install
bind -M insert "ç" fzf-cd-widget # to use ALT-C properly on MAC-OS
# FZF defaults
set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git --exclude node_modules . \$dir"
set -gx FZF_DEFAULT_OPTS "--height 99% --layout=reverse --border --preview-window down:15 --preview 'bat --color=always {}'"
# CTRL-T command
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
# ALT-C command
set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git --exclude node_modules . \$dir"
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
#                          ABBR                            #
############################################################
# source this config file
abbr so 'source ~/.config/fish/config.fish'
# Java home
abbr java11 'set -x JAVA_HOME (/usr/libexec/java_home -v11)'
abbr java17 'set -x JAVA_HOME (/usr/libexec/java_home -v17)'
abbr java21 'set -x JAVA_HOME (/usr/libexec/java_home -v21)'
abbr java22 'set -x JAVA_HOME (/usr/libexec/java_home -v22)'
abbr java23 'set -x JAVA_HOME (/usr/libexec/java_home -v23)'
# nvim minimal
abbr vim 'nvim --clean -u ~/.config/nvim-minimal/init.lua'
# python3
abbr python 'python3'
# R
abbr R 'R --no-save'
# LSD
abbr ll 'lsd --header --long --group-directories-first'
abbr ls 'lsd'
# eigencard as podata
abbr podata 'eigencard.py -c "Reader\\(2\\)"'
abbr eigencard 'java -jar ~/Dropbox/bin/eigencard.jar'
# config files
abbr dotfiles 'cd ~/dotfiles/ && nvim .'
abbr nvimrc 'cd ~/.config/nvim/ && nvim .'
abbr vimrc 'vim ~/.config/nvim-minimal/init.lua'
abbr fishrc 'nvim ~/.config/fish/config.fish'
abbr kittyrc 'nvim ~/.config/kitty/kitty.conf'
# dropbox quick access
#set DROPBOX ~/Library/CloudStorage/Dropbox
set DROPBOX ~/Dropbox
abbr cl "cd $DROPBOX && pwd && ll"
abbr notas "cd $DROPBOX/notas/trabajo && nvim ."
abbr bin "cd $DROPBOX/bin/ && nvim ."
abbr org "open '/Applications/Emacs.app' --args '$DROPBOX/notas/org/'"
abbr pyscard "cd '$DROPBOX/dev/SEMOVI/Pyscard scripts/' && nvim ."
# utils
abbr duh "du -ah . | sort -k1,1 -h | tail"

# Find file and cd to parent dir
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

eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/python/bin/activate.fish
