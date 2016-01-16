# desk.fish - desk completions for fish shell
#
# To install the completions:
# mkdir -p ~/.config/fish/completions
# cp desk.fish ~/.config/fish/completions

function __fish_desk_no_subcommand --description 'Test if desk has yet to be given a subcommand'
    for i in (commandline -opc)
        if contains -- $i init list ls . go run edit help version
            return 1
        end
    end
    return 0
end

# desk
complete -c desk -f -n '__fish_desk_no_subcommand' -a init -d 'Initialize desk configuration'

# desk list|ls
complete -c desk -f -n '__fish_desk_no_subcommand' -a "ls list" -d 'List all desks along with a description'
complete -c desk -A -f -n '__fish_seen_subcommand_from ls list' -l only-names -d 'List only the names of the desks'
complete -c desk -A -f -n '__fish_seen_subcommand_from ls list' -l no-format -d "Use ' - ' to separate names from descriptions"

# desk go|.
complete -c desk -f -n '__fish_desk_no_subcommand' -a "go ." -d 'Activate a desk. Extra arguments are passed onto shell'
complete -c desk -A -f -n '__fish_seen_subcommand_from . go' -a "(desk ls --only-names)" -d "Desk"

# desk run
complete -c desk -f -n '__fish_desk_no_subcommand' -a run -d 'Run a command within a desk\'s environment then exit'
complete -c desk -A -f -n '__fish_seen_subcommand_from run' -a '(desk ls --only-names)' -d "Desk"

# desk edit
complete -c desk -f -n '__fish_desk_no_subcommand' -a edit -d 'Edit (or create) a deskfile with the name specified, otherwise edit the active deskfile'
complete -c desk -A -f -n '__fish_seen_subcommand_from edit' -a '(desk ls --only-names)' -d "Desk"

# desk help
complete -c desk -f -n '__fish_desk_no_subcommand' -a help -d 'Show help text'

# desk version
complete -c desk -f -n '__fish_desk_no_subcommand' -a version -d 'Show version information'
