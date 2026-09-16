function __fzf_clear_images --description 'Drop any Kitty-protocol image an fzf preview left on screen'
    # fzf exiting does not remove image placements, only characters. Mirrors
    # the delete emitted at the top of fzf-preview.sh, and is likewise gated
    # on terminals that speak the protocol so nothing else sees stray bytes.
    switch "$TERM_PROGRAM:$TERM"
        case 'ghostty:*' '*:*kitty*' '*:*ghostty*' 'WezTerm:*'
            printf '\033_Ga=d,d=A\033\\'
    end
end
