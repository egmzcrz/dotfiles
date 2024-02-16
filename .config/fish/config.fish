if status is-interactive
  # Commands to run in interactive sessions can go here
end

# java home
alias java11="set -x JAVA_HOME (/usr/libexec/java_home -v11)"
alias java21="set -x JAVA_HOME (/usr/libexec/java_home -v21)"

#fish_vi_key_bindings
fish_hybrid_key_bindings
# fish fzf bindings
fzf_configure_bindings --directory=\ct

###########
# Aliases #
###########
set DROPBOX /Users/henry/Library/CloudStorage/Dropbox

# fish source
alias so='source ~/.config/fish/config.fish'

# bin aliases
alias vim='nvim --clean -u /Users/henry/.config/nvim-minimal/init.lua'
alias python='python3'
alias ll='exa --long --icons'

# config files
alias dotfiles='cd ~/dotfiles/ && goto_file'
alias nvimrc='cd ~/.config/nvim/ && goto_file'
alias vimrc='vim ~/.config/nvim-minimal/init.lua'
alias fishrc='nvim ~/.config/fish/config.fish'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'

# quick access
alias cdcloud="cd $DROPBOX && search_dirs"
alias sfcloud="cd $DROPBOX && search_files"
alias notas="cd $DROPBOX/notas/ && goto_file"
alias org="open /Applications/Emacs.app --args "$DROPBOX/notas/org/""
alias bin="cd /Users/henry/Library/CloudStorage/Dropbox/bin/ && search_files"
alias pyscard='cd "/Users/henry/Library/CloudStorage/Dropbox/dev/CDMX Ticketing Software/Pyscard scripts/" && search_files'
alias podata='eigencard.py -c "Reader\\(2\\)"'

function zipper
  if set -q argv[1]
    zip -r output.zip $argv[1] -x ".*" -x "__MACOSX"
  else
    zip -r output.zip . -x ".*" -x "__MACOSX"
  end
end

function boxshell
  if set -q argv[2]
    echo $argv[1] | boxes -d shell -a hc -s $argv[2]
  else
    echo $argv[1] | boxes -d shell -a hc
  end
end

function boxcpp
  if set -q argv[2]
    echo $argv[1] | boxes -d jstone -a hc -s $argv[2]
  else
    echo $argv[1] | boxes -d jstone -a hc
  end
end

function search_files
  export FZF_DEFAULT_COMMAND="fd --hidden --type f . \$dir"
  set path (fzf --preview "bat --color=always {}")
  if test -n "$path"
    cd $(dirname $path)
  end
  export FZF_DEFAULT_COMMAND="fd --hidden --type f --type d . \$dir"
end

function goto_file
  export FZF_DEFAULT_COMMAND="fd --hidden --type f . \$dir"
  set path (fzf --preview "bat --color=always {}")
  if test -n "$path"
    nvim $path
  end
  export FZF_DEFAULT_COMMAND="fd --hidden --type f --type d . \$dir"
end

function search_dirs
  export FZF_DEFAULT_COMMAND="fd --hidden --type d . \$dir"
  set path (fzf --preview "exa --tree --level 3 {}")
  if test -n "$path"
    cd $path
  end
  export FZF_DEFAULT_COMMAND="fd --hidden --type f --type d . \$dir"
end

###########
# Exports #
###########
export FZF_DEFAULT_COMMAND="fd --hidden --type f --type d . \$dir"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

eval "$(/opt/homebrew/bin/brew shellenv)"
