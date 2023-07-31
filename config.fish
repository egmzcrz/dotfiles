if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_vi_key_bindings


###########
# Aliases #
###########

alias so='source ~/.config/fish/config.fish'

# bin aliases
alias vim='nvim'
alias python='python3'
alias rc='radix-calc'
alias ll='exa --long --icons'

# config files
alias vimrc='cd ~/.config/nvim/ && explore'
alias fishrc='vim ~/.config/fish/config.fish'
alias kittyrc='vim ~/.config/kitty/kitty.conf'

# quick access
alias home='cd /Users/henry/Library/CloudStorage/Dropbox'
alias todo='cd /Users/henry/Library/CloudStorage/Dropbox/notas/trabajo/ && vim todo.md'
alias notes='cd /Users/henry/Library/CloudStorage/Dropbox/notas/trabajo/ && explore'
alias bin='cd /Users/henry/Library/CloudStorage/Dropbox/bin/ && explore'
alias pyscard='cd /Users/henry/Library/CloudStorage/Dropbox/dev/tools/pyscard/ && explore'

function boxshell
  echo $argv[1] | boxes -d shell
end

function boxcpp
  echo $argv[1] | boxes -d jstone
end

function explore
  set path (fzf --preview "bat --color=always {}")
  if test -n "$path"
    vim $path
  end
end

###########
# Exports #
###########

export FZF_DEFAULT_COMMAND="fd --type f --type d . \$dir"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
