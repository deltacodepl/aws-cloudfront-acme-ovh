
# export TF_LOG=TRACE
# export TF_LOG_PATH="./terraform.log"

data "sops_file" "demo-secret" {
  source_file = "ovh-keys.enc.json"
}

