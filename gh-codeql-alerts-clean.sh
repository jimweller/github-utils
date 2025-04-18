#!/bin/bash

# This script removes all old dynamic CodeQL reports from a Github repository so it does not cause conflicts with the ones reported by CircleCI
# See https://github.com/github/codeql-action/issues/1179
# Is adapted from @amoreas
# https://github.com/github/codeql-action/issues/1179#issuecomment-2050937338

usage() {
    scriptname=$(basename "$0")
    echo
    echo "USAGE:"
    echo "$scriptname ORG REPO1 [REPO2 ...]"
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg repo1 repo2 repo3"
}

OWNER="$1"
shift
REPOS=($@)

if [ -z "$OWNER" ]; then echo "error: no org specified"; usage; exit 1; fi
if [ ${#REPOS[@]} -eq 0 ]; then echo "error: no repo specified"; usage; exit 1; fi

for REPO in "${REPOS[@]}"; do
  echo "Checking repo: ${REPO}"
  RESULTS=$(gh api "/repos/${OWNER}/${REPO}/code-scanning/analyses" \
    --paginate \
    -H "Accept: application/vnd.github+json" 2>/dev/null || echo "")

  if [ -z "$RESULTS" ] || ! echo "$RESULTS" | jq -e 'type == "array"' >/dev/null 2>&1; then
    echo "Failed to fetch valid results for ${REPO}"
    continue
  fi

  URLS=($(echo "$RESULTS" | jq -r '.[] | select(.analysis_key | contains("dynamic")) | select(.deletable == true) | .url'))
  COUNT=${#URLS[@]}
  echo "Deletable dynamic analysis records: $COUNT"

  [ $COUNT -eq 0 ] && continue

  for URL in "${URLS[@]}"; do
    gh api --method DELETE "${URL}?confirm_delete=true" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28"
  done

  sleep 5
done
