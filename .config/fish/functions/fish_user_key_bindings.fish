# CTRL-T previews files through fzf-preview.sh, so it can leave an image
# behind when it exits. Wrap the stock widget rather than editing
# fzf_key_bindings.fish, which is a symlink into the Homebrew install.
function __fzf_file_widget_clear
    fzf-file-widget
    __fzf_clear_images
    commandline -f repaint
end

function fish_user_key_bindings
    fzf_key_bindings

    # Must come after fzf_key_bindings: it is what defines the widgets,
    # and it binds CTRL-T itself in both default and insert mode.
    bind \ct __fzf_file_widget_clear
    bind -M insert \ct __fzf_file_widget_clear

    bind -M insert ç fzf-cd-widget # to use ALT-C properly on MAC-OS
end
