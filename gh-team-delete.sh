#!/bin/bash

ORG=$1
TEAM=$2

usage() { 
    scriptname=$(basename $0) 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG TEAM"
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg example-team"
}

if [ -z $ORG ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $TEAM ]; then echo "error: no team specified"; usage; exit 1; fi

gh api --method DELETE \
  -H "Accept: application/vnd.github.v3+json" \
  "/orgs/$ORG/teams/$TEAM"

echo "Team '$TEAM' deleted from organization '$ORG'."
