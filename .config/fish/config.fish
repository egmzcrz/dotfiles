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
set -gx EDITOR vim
set -gx VISUAL vim
set DROPBOX /Users/henry/Library/CloudStorage/Dropbox

# fish source
alias so='source ~/.config/fish/config.fish'

# bin aliases
alias vim='nvim --clean -u /Users/henry/.config/nvim-minimal/init.lua'
alias python='python3'
alias ll='exa --long --icons'

# config files
alias dotfiles='cd ~/dotfiles/'
alias nvimrc='cd ~/.config/nvim/'
alias vimrc='vim ~/.config/nvim-minimal/init.lua'
alias fishrc='nvim ~/.config/fish/config.fish'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'

# quick access
alias cl="cd $DROPBOX"
alias notas="cd $DROPBOX/notas/trabajo && nvim ."
alias bin="cd $DROPBOX/bin/ && nvim ."

alias org="open '/Applications/Emacs.app' --args '$DROPBOX/notas/org/'"
alias pyscard="cd '$DROPBOX/dev/CDMX Ticketing Software/Pyscard scripts/' && nvim ."
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

function ff
  export FZF_DEFAULT_COMMAND="fd --hidden --type f . \$dir"
  set path (fzf --preview "bat --color=always {}")
  if test -n "$path"
    cd $(dirname $path)
  end
  export FZF_DEFAULT_COMMAND="fd --hidden --type f --type d . \$dir"
end

function gf
  export FZF_DEFAULT_COMMAND="fd --hidden --type f . \$dir"
  set path (fzf --preview "bat --color=always {}")
  if test -n "$path"
    nvim $path
  end
  export FZF_DEFAULT_COMMAND="fd --hidden --type f --type d . \$dir"
end

function gd
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
