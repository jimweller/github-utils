#!/bin/bash

ORG=$1
TEAM=$2
VISIBILITY=$3

usage() { 
    scriptname=$(basename $0) 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG TEAM VISIBILITY [user1] [user2] [user3] ..."
    echo
    echo "VISIBILITY:"
    echo "  secret - The team is only visible to its members"
    echo "  closed - The team is visible to all members of the organization"
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg example-team closed user1 user2 user3"
}

if [ -z $ORG ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $TEAM ]; then echo "error: no team specified"; usage; exit 1; fi
if [ -z $VISIBILITY ]; then echo "error: no visibility specified"; usage; exit 1; fi

if [[ "$VISIBILITY" != "secret" && "$VISIBILITY" != "closed" ]]; then
    echo "error: invalid visibility '$VISIBILITY'. Must be 'secret' or 'closed'."
    usage
    exit 1
fi

shift 3

gh api --method POST \
  -H "Accept: application/vnd.github.v3+json" \
  "/orgs/$ORG/teams" \
  -f name="$TEAM" \
  -f privacy="$VISIBILITY"

USERS_ADDED=""

for USER in "$@"; do
  gh api --method PUT \
    -H "Accept: application/vnd.github.v3+json" \
    "/orgs/$ORG/teams/$TEAM/memberships/$USER" \
    -f role=member
  USERS_ADDED+="$USER "
done

echo "Team '$TEAM' created in organization '$ORG' with visibility '$VISIBILITY'. Users added: $USERS_ADDED"
