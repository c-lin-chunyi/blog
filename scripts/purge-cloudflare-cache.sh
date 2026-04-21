#!/usr/bin/env bash
set -euo pipefail

CF_API_TOKEN_VALUE="${CF_API_TOKEN:-${CLOUDFLARE_API_TOKEN:-}}"
CF_ZONE_ID_VALUE="${CF_ZONE_ID:-${CLOUDFLARE_ZONE_ID:-}}"

if [[ -z "${CF_API_TOKEN_VALUE}" ]]; then
  echo "Set CF_API_TOKEN to a Cloudflare API token that can purge zone cache." >&2
  exit 1
fi

if [[ -z "${CF_ZONE_ID_VALUE}" ]]; then
  echo "Set CF_ZONE_ID to the Cloudflare zone ID for this site." >&2
  exit 1
fi

purge_response="$(
  curl -fsS -X POST \
    "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID_VALUE}/purge_cache" \
    -H "Authorization: Bearer ${CF_API_TOKEN_VALUE}" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything":true}'
)"

if [[ "${purge_response}" != *'"success":true'* ]]; then
  echo "Cloudflare cache purge failed." >&2
  echo "${purge_response}" >&2
  exit 1
fi

echo "Cloudflare zone cache purged."
