#!/usr/bin/env bash

# Loop through all *.template.env files in the current directory
for f in *.template.env; do
  # Skip if none found (glob didn’t match)
  [[ "$f" == "*.template.env" ]] && continue

  # Extract the service name (strip .template.env)
  service="${f%%.template.env}"

  echo "Processing service: $service"
  ./generate_service_env.sh "$service"
done
