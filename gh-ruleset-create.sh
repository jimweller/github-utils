#!/bin/bash

# Check for required arguments
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 <org> <repo> <ruleset_name> <ruleset_file>"
  exit 1
fi

# Command-line parameters
ORG="$1"
REPO="$2"
RULESET_NAME="$3"
RULESET_FILE="$4"

# Validate JSON file exists
if [ ! -f "$RULESET_FILE" ]; then
  echo "Error: Ruleset file '$RULESET_FILE' not found."
  exit 1
fi

# Construct the repository slug
REPO_SLUG="$ORG/$REPO"

# Load the JSON ruleset and add the name dynamically
RULESET_JSON=$(jq --arg name "$RULESET_NAME" '.name = $name' "$RULESET_FILE")

# Create the Ruleset using `gh api`
gh api "repos/$REPO_SLUG/rulesets" \
  --method POST \
  --header "Accept: application/vnd.github+json" \
  --input - <<< "$RULESET_JSON"
