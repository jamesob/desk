# Description: the desk I use to work on desk :)

cd ~/code/desk

# Run `make lint`
alias lint="make lint"

# Args: <github_pr_number>. Checkout a Github PR's branch for local testing.
checkout_pr () {
  git fetch origin pull/$1/head:pr-$1 && git checkout pr-$1;
}
