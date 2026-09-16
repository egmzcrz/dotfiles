#!/usr/bin/env bash
# Preview dispatcher for fzf: images and PDFs render as real images in
# terminals that speak the Kitty graphics protocol (Ghostty, kitty, WezTerm),
# text falls back to bat, directories to lsd.
#
# Wired up from config.fish via $FZF_DEFAULT_OPTS --preview.

set -u

file=${1:-}
[ -n "$file" ] || exit 0

# fzf exports the preview pane geometry; fall back to something sane when
# the script is run by hand.
cols=${FZF_PREVIEW_COLUMNS:-${COLUMNS:-80}}
lines=${FZF_PREVIEW_LINES:-${LINES:-25}}

# Only emit graphics escapes where the terminal can actually draw them,
# otherwise chafa's character-art mode still gives a usable picture.
case "${TERM_PROGRAM:-}:${TERM:-}" in
    ghostty:* | *:*kitty* | *:*ghostty* | WezTerm:*) chafa_format=kitty ;;
    *) chafa_format=symbols ;;
esac

# A Kitty-protocol image is a placement the terminal holds until told to
# drop it: fzf redrawing this pane as text overwrites the characters but
# leaves the picture on screen. So delete any previous placement on every
# run, whatever we are about to draw -- text and directories included.
if [ "$chafa_format" = kitty ]; then
    printf '\033_Ga=d,d=A\033\\'
fi

show_image() {
    chafa --format "$chafa_format" --size "${cols}x${lines}" --animate off --polite on -- "$1"
}

if [ -d "$file" ]; then
    lsd --color=always --group-directories-first --long --header -- "$file"
    exit 0
fi

if [ ! -r "$file" ]; then
    printf '%s: not readable\n' "$file"
    exit 0
fi

mime=$(file --mime-type -b -- "$file" 2>/dev/null || echo application/octet-stream)

case "$mime" in
    image/*)
        show_image "$file"
        ;;
    application/pdf)
        # Rasterise page 1 into a cache keyed by path + mtime, so scrolling
        # the file list does not re-render the same PDF over and over.
        cache_dir="${TMPDIR:-/tmp}/fzf-preview-cache"
        mkdir -p "$cache_dir"
        key=$(printf '%s' "$file" | shasum | cut -d' ' -f1)
        mtime=$(stat -f %m -- "$file" 2>/dev/null || echo 0)
        page="$cache_dir/$key-$mtime"
        [ -f "$page.png" ] || pdftoppm -png -r 120 -f 1 -l 1 -- "$file" "$page" >/dev/null 2>&1
        # pdftoppm appends a page suffix unless the doc has a single page
        for candidate in "$page.png" "$page-1.png" "$page-01.png"; do
            if [ -f "$candidate" ]; then
                show_image "$candidate"
                exit 0
            fi
        done
        # Rasterising failed: fall back to the text layer
        pdftotext -l 2 -- "$file" - 2>/dev/null | head -n "$lines"
        ;;
    text/* | application/json | application/javascript | application/xml | inode/x-empty)
        bat --color=always --style=numbers --line-range ":$((lines * 2))" -- "$file"
        ;;
    *)
        # Let bat try (it knows more formats than `file` reports), else describe it
        if bat --color=always --style=numbers --line-range ":$((lines * 2))" -- "$file" 2>/dev/null; then
            :
        else
            file -b -- "$file"
        fi
        ;;
esac
