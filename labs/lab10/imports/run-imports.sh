#!/usr/bin/env bash
set -euo pipefail

# Batch import helper for Lab 10 using the paths generated in this repo.
#
# Usage:
#   export DD_URL="http://localhost:8080"
#   export DD_TOKEN="<api-token>"
#   export ENGAGEMENT_ID="<engagement-id>"
#   bash labs/lab10/imports/run-imports.sh

require_env() {
  local name="$1"
  if [[ -z "${!name:-}" ]]; then
    echo "ERROR: env var $name is required" >&2
    exit 1
  fi
}

require_env DD_URL
require_env DD_TOKEN
require_env ENGAGEMENT_ID

out_dir="labs/lab10/work/import-responses"
mkdir -p "$out_dir"

import_scan() {
  local label="$1"
  local scan_type="$2"
  local file="$3"
  local out="$out_dir/$label.json"

  if [[ ! -f "$file" ]]; then
    echo "SKIP: $label missing file: $file"
    return 0
  fi

  echo "Importing $label as $scan_type"
  curl -sS -X POST "$DD_URL/api/v2/import-scan/" \
    -H "Authorization: Token $DD_TOKEN" \
    -F "scan_type=$scan_type" \
    -F "engagement=$ENGAGEMENT_ID" \
    -F "file=@$file" \
    -F "minimum_severity=Info" \
    -F "active=true" \
    -F "verified=true" \
    -F "close_old_findings=false" \
    -F "push_to_jira=false" | tee "$out"
  echo
}

import_scan lab4-grype "Anchore Grype" "labs/lab4/grype-from-sbom.json"
import_scan lab4-trivy "Trivy Scan" "labs/lab4/trivy.json"
import_scan lab5-semgrep "Semgrep JSON Report" "labs/lab5/results/semgrep.json"
import_scan lab6-checkov-terraform "Checkov Scan" "labs/lab6/results/checkov-terraform/results_json.json"
import_scan lab6-kics-ansible "KICS Scan" "labs/lab6/results/kics-ansible/results.json"
import_scan lab6-kics-pulumi "KICS Scan" "labs/lab6/results/kics-pulumi/results.json"
import_scan lab7-trivy-image "Trivy Scan" "labs/lab7/results/trivy-image.json"
import_scan lab7-trivy-k8s "Trivy Operator Scan" "labs/lab7/results/trivy-k8s.json"

cat <<'EOF'

Notes:
- labs/lab5/results/auth-report.json is a ZAP JSON report. This DefectDojo version exposes
  "ZAP Scan" as an XML parser, so convert the JSON to OWASP ZAP XML before importing.
- labs/lab9/falco/logs/falco.log is a custom runtime log and is documented in the submission
  rather than imported through a built-in parser.
EOF
