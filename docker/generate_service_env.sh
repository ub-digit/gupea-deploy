#!/usr/bin/env bash
set -euo pipefail

SERVICE="${1:-}"

if [[ -z "$SERVICE" ]]; then
  echo "Usage: $0 <service_name>"
  exit 1
fi

# --- CONFIG ---
BASE_ENV="./.env"
TEMPLATE_ENV="./$SERVICE.template.env"
OUTPUT_ENV="./$SERVICE.service.env"

if [[ ! -f "$TEMPLATE_ENV" ]]; then
  echo "Template env file not found: $TEMPLATE_ENV"
  exit 1
fi

echo "⚙️  Generating ${OUTPUT_ENV} from ${TEMPLATE_ENV} ..."

# --- LOAD BASE ENV ---
set -a
source "$BASE_ENV"
set +a

# --- PARSE VARIABLE NAMES FROM SERVICE FILE ---
# This extracts just the variable names (left side of '=') from .env_service
mapfile -t VAR_NAMES < <(grep -v '^\s*#' "$TEMPLATE_ENV" | grep '=' | cut -d '=' -f1)

# --- LOAD SERVICE ENV (with interpolation from BASE_ENV) ---
set -a
source "$TEMPLATE_ENV"
set +a

# --- WRITE RESOLVED VALUES ONLY FOR VARIABLES DEFINED IN .env_service ---
{
  for var in "${VAR_NAMES[@]}"; do
    # Only print if the variable is set
    if [[ -n "${!var-}" ]]; then
      printf '%s="%s"\n' "$var" "${!var}"
    fi
  done
} > "$OUTPUT_ENV"

echo "✅ Created $OUTPUT_ENV"
