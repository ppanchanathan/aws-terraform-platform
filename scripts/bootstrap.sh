#!/usr/bin/env bash
set -euo pipefail

cd bootstrap
terraform init
terraform plan
terraform apply
