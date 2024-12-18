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

USERS_REMOVED=""

for USER in "$@"; do
  gh api --method DELETE \
    -H "Accept: application/vnd.github.v3+json" \
    "/orgs/$ORG/teams/$TEAM/memberships/$USER"
  USERS_REMOVED+="$USER "
done

echo "Users removed from team '$TEAM' in organization '$ORG': $USERS_REMOVED"
