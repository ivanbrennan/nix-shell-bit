Resolving dependencies...
_nix-shell-bit()
{
    local CMDLINE
    local IFS=$'\n'
    CMDLINE=(--bash-completion-index $COMP_CWORD)

    for arg in ${COMP_WORDS[@]}; do
        CMDLINE=(${CMDLINE[@]} --bash-completion-word $arg)
    done

    COMPREPLY=( $(nix-shell-bit "${CMDLINE[@]}") )
}

complete -o filenames -F _nix-shell-bit nix-shell-bit
