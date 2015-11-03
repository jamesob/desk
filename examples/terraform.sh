# Description: desk for doing work on a terraform-based repository
#

cd ~/terraform-repo

# Set up AWS env variables: <key id> <secret>
set_aws_env() {
  export AWS_DEFAULT_REGION=us-west-1
  export AWS_ACCESS_KEY_ID="$1"
  export AWS_SECRET_ACCESS_KEY="$2"
}

# Run `terraform plan` with proper AWS var config
plan() {
  terraform plan -module-depth=-1 \
    -var "access_key=${AWS_ACCESS_KEY_ID}" \
    -var "secret_key=${AWS_SECRET_ACCESS_KEY}"
}

# Run `terraform apply` with proper AWS var config
apply () {
  terraform apply \
    -var "access_key=${AWS_ACCESS_KEY_ID}" \
    -var "secret_key=${AWS_SECRET_ACCESS_KEY}"
}

# Set up terraform config: <config_key>
config () {
  local KEY=$1
  terraform remote config -backend=s3 \
    -backend-config="bucket=some.bucket.secrets.terraform" \
    -backend-config="key=${KEY}"
}
