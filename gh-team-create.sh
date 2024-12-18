#!/bin/bash

ORG=$1
TEAM=$2
PARENT=$3
VISIBILITY=$4

usage() { 
    scriptname=$(basename $0) 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG TEAM PARENT VISIBILITY [user1] [user2] [user3] ..."
    echo
    echo "PARENT:"
    echo "  Use 'root' if the team has no parent"
    echo
    echo "VISIBILITY:"
    echo "  secret - The team is only visible to its members"
    echo "  closed - The team is visible to all members of the organization"
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg example-team root closed user1 user2 user3"
    echo "$scriptname ExampleOrg example-team parent-team secret user1 user2"
}

if [ -z $ORG ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $TEAM ]; then echo "error: no team specified"; usage; exit 1; fi
if [ -z $PARENT ]; then echo "error: no parent team specified"; usage; exit 1; fi
if [ -z $VISIBILITY ]; then echo "error: no visibility specified"; usage; exit 1; fi

if [[ "$VISIBILITY" != "secret" && "$VISIBILITY" != "closed" ]]; then
    echo "error: invalid visibility '$VISIBILITY'. Must be 'secret' or 'closed'."
    usage
    exit 1
fi

shift 4

if [ "$PARENT" == "root" ]; then
    PARENT_ID=""
else
    PARENT_ID=$(gh api -H "Accept: application/vnd.github.v3+json" "/orgs/$ORG/teams/$PARENT" --jq '.id')

    if [ -z "$PARENT_ID" ]; then
        echo "error: parent team '$PARENT' not found in organization '$ORG'"
        exit 1
    fi
fi

gh api --method POST \
  -H "Accept: application/vnd.github.v3+json" \
  "/orgs/$ORG/teams" \
  -f name="$TEAM" \
  ${PARENT_ID:+-f parent_team_id="$PARENT_ID"} \
  -f privacy="$VISIBILITY"

USERS_ADDED=""

for USER in "$@"; do
  gh api --method PUT \
    -H "Accept: application/vnd.github.v3+json" \
    "/orgs/$ORG/teams/$TEAM/memberships/$USER" \
    -f role=member
  USERS_ADDED+="$USER "
done

echo "Team '$TEAM' created under parent '$PARENT' in organization '$ORG' with visibility '$VISIBILITY'. Users added: $USERS_ADDED"
