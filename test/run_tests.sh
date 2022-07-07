#!/bin/bash

# Run automated tests to ensure desk is behaving as expected

ensure() {
  if [ $1 -ne 0 ]; then
    echo "Failed: $2"
    exit 1
  fi
}

ensure_not(){
  if [ $1 -eq 0 ]; then
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
echo "$HELP" | grep 'desk init' >/dev/null
ensure $? "Desk help doesn't contain init"
echo "$HELP" | grep 'desk (list|ls)' >/dev/null
ensure $? "Desk help doesn't contain list"
echo "$HELP" | grep 'desk (.|go)' >/dev/null
ensure $? "Desk help doesn't contain go"
echo "$HELP" | grep 'desk run' >/dev/null
ensure $? "Desk help doesn't contain run"
echo "$HELP" | grep 'desk help' >/dev/null
ensure $? "Desk help doesn't contain help"
echo "$HELP" | grep 'desk version' >/dev/null
ensure $? "Desk help doesn't contain version"

desk init <<ANSWER


ANSWER

LIST=$(DESK_DESKS_DIR=${HOME}/examples desk list)
echo "$LIST" | grep "desk            the desk I use to work on desk :)" >/dev/null
ensure $? "Desk list missing desk (with DESK_DESKS_DIR)"
echo "$LIST" | grep "python_project  desk for working on a Python project" >/dev/null
ensure $? "Desk list missing python_project (with DESK_DESKS_DIR)"
echo "$LIST" | grep "terraform       desk for doing work on a terraform-based repository" >/dev/null
ensure $? "Desk list missing terraform (with DESK_DESKS_DIR)"
echo "$LIST" | grep "hello           simple desk that says hello" >/dev/null
ensure $? "Desk list missing hello (with DESK_DESKS_DIR)"

rm -rf "$HOME/.desk/desks"
ln -s "$HOME/examples" "$HOME/.desk/desks"

## `desk list`

# --no-format
LIST=$(desk list --no-format)
echo "$LIST" | grep "desk - the desk I use to work on desk :)" >/dev/null
ensure $? "Desk list missing desk with --no-format option (with symlink)"
echo "$LIST" | grep "python_project - desk for working on a Python project" >/dev/null
ensure $? "Desk list missing python_project with --no-format option (with symlink)"
echo "$LIST" | grep "terraform - desk for doing work on a terraform-based repository" >/dev/null
ensure $? "Desk list missing terraform with --no-format option (with symlink)"
echo "$LIST" | grep "hello - simple desk that says hello" >/dev/null
ensure $? "Desk list missing hello (with symlink)"

# --only-names
LIST=$(desk list --only-names)
echo "$LIST" | grep "the desk I use to work on desk :)" >/dev/null
ensure_not $? "Desk list --only-names contains 'desk' description (with symlink)"
echo "$LIST" | grep -e '^desk$' >/dev/null
ensure $? "Desk list --only-names missing 'desk' (with symlink)"

# without options
LIST=$(desk list)
echo "$LIST" | grep "desk            the desk I use to work on desk :)" >/dev/null
ensure $? "Desk list did not align 'desk' (with symlink)"
echo "$LIST" | grep "python_project  desk for working on a Python project" >/dev/null
ensure $? "Desk list did not align 'python_project' (with symlink)"
echo "$LIST" | grep "terraform       desk for doing work on a terraform-based repository" >/dev/null
ensure $? "Desk list did not align 'terraform' (with symlink)"

# DESK_DESKS_DIR=...
rm -rf "$HOME/.desk/desks"
LIST=$(DESK_DESKS_DIR=$HOME/examples desk list)
echo "$LIST" | grep "desk            the desk I use to work on desk :)" >/dev/null
ensure $? "Desk list missing desk (with DESK_DESKS_DIR)"
echo "$LIST" | grep "python_project  desk for working on a Python project" >/dev/null
ensure $? "Desk list missing python_project (with DESK_DESKS_DIR)"
echo "$LIST" | grep "terraform       desk for doing work on a terraform-based repository" >/dev/null
ensure $? "Desk list missing terraform (with DESK_DESKS_DIR)"

ln -s "$HOME/examples" "$HOME/.desk/desks"

mkdir ~/terraform-repo

## `desk`

# without options
CURRENT=$(DESK_ENV=$HOME/.desk/desks/terraform.sh desk)
echo "$CURRENT" | grep 'set_aws_env  Set up AWS env variables: <key id> <secret>' >/dev/null
ensure $? "Desk current terraform missing set_aws_env"
echo "$CURRENT" | grep 'plan         Run `terraform plan` with proper AWS var config' >/dev/null
ensure $? "Desk current terraform missing plan"
echo "$CURRENT" | grep 'apply        Run `terraform apply` with proper AWS var config' >/dev/null
ensure $? "Desk current terraform missing apply"
echo "$CURRENT" | grep 'config       Set up terraform config: <config_key>' >/dev/null
ensure $? "Desk current terraform missing config"

# --no-format
CURRENT=$(DESK_ENV=$HOME/.desk/desks/terraform.sh desk --no-format)
echo "$CURRENT" | grep 'set_aws_env - Set up AWS env variables: <key id> <secret>' >/dev/null
ensure $? "Desk current terraform missing set_aws_env"
echo "$CURRENT" | grep 'plan - Run `terraform plan` with proper AWS var config' >/dev/null
ensure $? "Desk current terraform missing plan"
echo "$CURRENT" | grep 'apply - Run `terraform apply` with proper AWS var config' >/dev/null
ensure $? "Desk current terraform missing apply"
echo "$CURRENT" | grep 'config - Set up terraform config: <config_key>' >/dev/null
ensure $? "Desk current terraform missing config"

# testing for exported variables
CURRENT=$(DESK_ENV=$HOME/.desk/desks/hello.sh desk)
echo "$CURRENT" | grep 'MyName  Why should I always type my name' >/dev/null
ensure $? "Desk current hello missing exported environment variable"


RAN=$(desk run hello 'howdy james!')
echo "$RAN" | grep 'howdy y'"'"'all james!' >/dev/null
ensure $? "Run in desk 'hello' didn't work with howdy alias"

RAN=$(desk run hello 'hi j')
echo "$RAN" | grep 'hi, j!' >/dev/null
ensure $? "Run in desk 'hello' didn't work with hi function"

RAN=$(desk run hello 'echo $MyName')
echo "$RAN" | grep 'James' >/dev/null
ensure $? "Run in desk 'hello' didn't work with MyName exported variable"

RAN=$(desk run hello echo ahoy matey)
echo "$RAN" | grep 'ahoy matey' >/dev/null
ensure $? "Run in desk 'hello' didn't work with argument vector"

## `desk go`

RAN=$(desk go example-project/Deskfile -c 'desk ; exit')
echo "$RAN" | grep "example-project - simple desk that says hello" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"
echo "$RAN" | grep -E "hi\s+" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"
echo "$RAN" | grep -E "howdy\s+" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"

RAN=$(desk go example-project/ -c 'desk ; exit')
echo "$RAN" | grep "example-project - simple desk that says hello" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"
echo "$RAN" | grep -E "hi\s+" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"
echo "$RAN" | grep -E "howdy\s+" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"

pushd example-project >/dev/null

RAN=$(desk go . -c 'desk ; exit')
echo "$RAN" | grep "example-project - simple desk that says hello" >/dev/null
ensure $? "Deskfile invocation didn't work (./)"
echo "$RAN" | grep -E "hi\s+" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"
echo "$RAN" | grep -E "howdy\s+" >/dev/null
ensure $? "Deskfile invocation didn't work (example-project/)"

popd >/dev/null

## `desk load`

pushd example-project >/dev/null

RAN=$($SHELL -c 'eval $(desk load); desk; exit')
echo "$RAN" | grep "example-project - simple desk that says hello" >/dev/null
ensure $? "Deskfile load didn't work (./)"
echo "$RAN" | grep -E "hi\s+" >/dev/null
ensure $? "Deskfile load didn't work (example-project/)"
echo "$RAN" | grep -E "howdy\s+" >/dev/null
ensure $? "Deskfile load didn't work (example-project/)"

popd >/dev/null
                     
echo "tests pass."
