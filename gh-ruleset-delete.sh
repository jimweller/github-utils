#!/bin/bash

# Usage: ./delete_ruleset.sh <org> <repo> <ruleset_name>
# Example: ./delete_ruleset.sh ExampleCo MyRepo strict

# Check for required arguments
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <org> <repo> <ruleset_name>"
  exit 1
fi

# Command-line parameters
ORG="$1"
REPO="$2"
RULESET_NAME="$3"

# Construct the repository slug
REPO_SLUG="$ORG/$REPO"

# Find the ruleset ID by filtering for the name
RULESET_ID=$(gh api "repos/$REPO_SLUG/rulesets" \
  --jq ".[] | select(.name == \"$RULESET_NAME\") | .id")

# Validate if the ruleset ID was found
if [ -z "$RULESET_ID" ]; then
  echo "Error: Ruleset '$RULESET_NAME' not found in repository '$REPO_SLUG'."
  exit 1
fi

# Delete the ruleset using the ID
gh api "repos/$REPO_SLUG/rulesets/$RULESET_ID" \
  --method DELETE \
  --header "Accept: application/vnd.github+json"

echo "Ruleset '$RULESET_NAME' (ID: $RULESET_ID) has been deleted from '$REPO_SLUG'."
