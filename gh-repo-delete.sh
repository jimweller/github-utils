#!/bin/sh

# delete a repo

owner=$1
repo=$2
branch=main
teamtopic=team-cloud-enablement

usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG REPO"
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg my-new-repo"
}


if [ -z $owner ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $repo ]; then echo "error: no repo specified"; usage; exit 1; fi

gh repo delete --yes $owner/$repo