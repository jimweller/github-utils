#!/bin/bash

ORG=$1
TEAM=$2

usage() { 
    scriptname=$(basename $0) 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG TEAM [user1] [user2] [user3] ..."
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg example-team user1 user2 user3"
}

if [ -z $ORG ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $TEAM ]; then echo "error: no team specified"; usage; exit 1; fi
if [ $# -lt 3 ]; then echo "error: no users specified"; usage; exit 1; fi

shift 2

USERS_ADDED=""

for USER in "$@"; do
  gh api --method PUT \
    -H "Accept: application/vnd.github.v3+json" \
    "/orgs/$ORG/teams/$TEAM/memberships/$USER" \
    -f role=member
  USERS_ADDED+="$USER "
done

echo "Users added to team '$TEAM' in organization '$ORG': $USERS_ADDED"
