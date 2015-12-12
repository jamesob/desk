#compdef desk
#autoload

_all_desks() {
  desks=($(desk list --only-names))
}

local expl
local -a desks

local -a _subcommands
_subcommands=(
  'help:Print a help message.'
  'init:Initialize your desk configuration.'
  'list:List available desks'
  'ls:List available desks'
  'edit:Edit or create a desk, defaults to current desk'
  'go:Activate a desk'
  '.:Activate a desk'
  'run:Run a command within a desk environment'
  'version:Show the desk version.'
)

if (( CURRENT == 2 )); then
  _describe -t commands 'desk subcommand' _subcommands
  return
fi

case "$words[2]" in
  go|.|edit|run)
    _all_desks
    _wanted desks expl 'desks' compadd -a desks ;;
esac
