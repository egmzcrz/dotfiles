if status is-interactive
    # Commands to run in interactive sessions can go here
end

#fish_vi_key_bindings
fish_hybrid_key_bindings
# fish fzf bindings
fzf_configure_bindings --directory=\ct

###########
# Aliases #
###########

alias so='source ~/.config/fish/config.fish'

# bin aliases
alias vim='nvim --clean -u /Users/henry/.config/nvim-minimal/init.lua'
alias python='python3'
alias rc='radix-calc'
alias ll='exa --long --icons'

# config files
alias dotfiles='cd ~/dotfiles/ && explore'
alias nvimrc='cd ~/.config/nvim/ && explore'
alias vimrc='vim ~/.config/nvim-minimal/init.lua'
alias fishrc='nvim ~/.config/fish/config.fish'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'

# quick access
alias dropbox='cd /Users/henry/Library/CloudStorage/Dropbox'
alias todo='cd /Users/henry/Library/CloudStorage/Dropbox/notas/trabajo/ && nvim todo.md'
alias notas='cd /Users/henry/Library/CloudStorage/Dropbox/notas/trabajo/ && explore'
alias org='cd /Users/henry/Library/CloudStorage/Dropbox/notas/org/ && explore'
alias papa='cd /Users/henry/Library/CloudStorage/Dropbox/notas/papa/ && explore'
alias bin='cd /Users/henry/Library/CloudStorage/Dropbox/bin/ && explore'
alias pyscard='cd "/Users/henry/Library/CloudStorage/Dropbox/dev/CDMX Ticketing Software/Pyscard scripts/" && explore'
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

function explore
  set path (fzf --preview "bat --color=always {}")
  if test -n "$path"
    nvim $path
  end
end

###########
# Exports #
###########
export FZF_DEFAULT_COMMAND="fd -H --type f --type d . \$dir"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

eval "$(/opt/homebrew/bin/brew shellenv)"
