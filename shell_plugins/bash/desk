#Bash completion for ◲ desk

_desk() {
    PREFIX="${DESK_DIR:-$HOME/.desk}"
    DESKS="${DESK_DESKS_DIR:-$PREFIX/desks}"

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    case ${COMP_CWORD} in
        1)
            COMPREPLY=($(compgen -W "edit . go run help init list ls version" ${cur}))
            ;;
        2)
            case ${prev} in
                edit|go|.|run)
                    if [[ -d $DESKS ]]; then
                        local desks=$(desk list --only-names)
                    else
                        local desks=""
                    fi
                    COMPREPLY=( $(compgen -W "${desks}" -- ${cur}) )
                    ;;
            esac
            ;;
        *)
            COMPREPLY=()
            ;;
    esac
}


complete -F _desk desk
