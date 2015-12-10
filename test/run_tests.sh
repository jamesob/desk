#!/bin/bash

# Run automated tests to ensure desk is behaving as expected

ensure() {
  if [ $1 -ne 0 ]; then
    echo "Failed: $2"
    exit 1
  fi
}

desk | grep "No desk activated." >/dev/null
ensure $? "Desk without desk activated fails."
desk --version | grep "◲  desk " >/dev/null
ensure $? "Desk version fails."

HELP=$(desk help)
ensure $? "Desk help fails."
echo $HELP | grep 'desk init' >/dev/null
ensure $? "Desk help doesn't contain init"
echo $HELP | grep 'desk (list|ls)' >/dev/null
ensure $? "Desk help doesn't contain list"
echo $HELP | grep 'desk (.|go)' >/dev/null
ensure $? "Desk help doesn't contain go"
echo $HELP | grep 'desk run' >/dev/null
ensure $? "Desk help doesn't contain run"
echo $HELP | grep 'desk help' >/dev/null
ensure $? "Desk help doesn't contain help"
echo $HELP | grep 'desk version' >/dev/null
ensure $? "Desk help doesn't contain version"

desk init <<ANSWER


ANSWER

LIST=$(DESK_DESKS_DIR=${HOME}/examples desk list)
echo $LIST | grep "desk - the desk I use to work on desk :)" >/dev/null
ensure $? "Desk list missing desk (with DESK_DESKS_DIR)"
echo $LIST | grep "python_project - desk for working on a Python project" >/dev/null
ensure $? "Desk list missing python_project (with DESK_DESKS_DIR)"
echo $LIST | grep "terraform - desk for doing work on a terraform-based repository" >/dev/null
ensure $? "Desk list missing terraform (with DESK_DESKS_DIR)"
echo $LIST | grep "hello - simple desk that says hello" >/dev/null
ensure $? "Desk list missing hello (with DESK_DESKS_DIR)"

rm -rf "$HOME/.desk/desks"
ln -s "$HOME/examples" "$HOME/.desk/desks"
 
LIST=$(desk list)
echo $LIST | grep "desk - the desk I use to work on desk :)" >/dev/null
ensure $? "Desk list missing desk (with symlink)"
echo $LIST | grep "python_project - desk for working on a Python project" >/dev/null
ensure $? "Desk list missing python_project (with symlink)"
echo $LIST | grep "terraform - desk for doing work on a terraform-based repository" >/dev/null
ensure $? "Desk list missing terraform (with symlink)"
echo $LIST | grep "hello - simple desk that says hello" >/dev/null
ensure $? "Desk list missing hello (with symlink)"

mkdir ~/terraform-repo

CURRENT=$(DESK_ENV=$HOME/.desk/desks/terraform.sh desk)
echo $CURRENT | grep 'set_aws_env - Set up AWS env variables: <key id> <secret>' >/dev/null
ensure $? "Desk current terraform missing set_aws_env"
echo $CURRENT | grep 'plan - Run `terraform plan` with proper AWS var config' >/dev/null
ensure $? "Desk current terraform missing plan"
echo $CURRENT | grep 'apply - Run `terraform apply` with proper AWS var config' >/dev/null
ensure $? "Desk current terraform missing apply"
echo $CURRENT | grep 'config - Set up terraform config: <config_key>' >/dev/null
ensure $? "Desk current terraform missing config"

RAN=$(desk run hello 'howdy james!')
echo $RAN | grep 'howdy there james!' >/dev/null
ensure $? "Run in desk 'hello' didn't work with howdy alias"

RAN=$(desk run hello 'hi j')
echo $RAN | grep 'hi, j!' >/dev/null
ensure $? "Run in desk 'hello' didn't work with hi function"

echo "tests pass."
