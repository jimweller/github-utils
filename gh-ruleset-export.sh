#!/bin/bash

# Usage: ./export_ruleset_clean.sh <org> <repo> <ruleset_name>
# Example: ./export_ruleset_clean.sh HylandSoftware fcc-demo-github-pr-triggers strict > clean_ruleset.json

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <org> <repo> <ruleset_name>"
  exit 1
fi

ORG="$1"
REPO="$2"
RULESET_NAME="$3"
REPO_SLUG="$ORG/$REPO"

# Get Ruleset ID
RULESET_ID=$(gh api "repos/$REPO_SLUG/rulesets" \
  --jq ".[] | select(.name == \"$RULESET_NAME\") | .id")

if [ -z "$RULESET_ID" ]; then
  echo "Error: Ruleset '$RULESET_NAME' not found."
  exit 1
fi

# Fetch and clean the ruleset
gh api "repos/$REPO_SLUG/rulesets/$RULESET_ID" \
  --method GET | jq 'del(.node_id, .created_at, .updated_at, ._links)'
