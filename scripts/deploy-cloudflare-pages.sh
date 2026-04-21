#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="${CF_PAGES_PROJECT_NAME:-${CLOUDFLARE_PAGES_PROJECT_NAME:-}}"
OUTPUT_DIR="${CF_PAGES_OUTPUT_DIR:-_site}"
BRANCH_NAME="${CF_PAGES_BRANCH:-$(git branch --show-current 2>/dev/null || true)}"

if [[ -z "${PROJECT_NAME}" ]]; then
  echo "Set CF_PAGES_PROJECT_NAME to your Cloudflare Pages project name." >&2
  exit 1
fi

npm ci
npm run build

args=(pages deploy "${OUTPUT_DIR}" --project-name="${PROJECT_NAME}")

if [[ -n "${BRANCH_NAME}" ]]; then
  args+=(--branch="${BRANCH_NAME}")
fi

npx wrangler "${args[@]}"
