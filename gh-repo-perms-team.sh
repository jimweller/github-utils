#!/bin/sh

# add a team to a repo with a specific permission

owner=$1
repo=$2
team=$3
perm=$4


usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG REPO TEAM PERMISSION"
    echo
    echo "permissions are one of DELETE, pull, triage, push, maintain, admin"
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg my-new-repo cpe-enablement maintain"
}


if [ -z $owner ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $repo ]; then echo "error: no repo specified"; usage; exit 1; fi
if [ -z $team ]; then echo "error: no team specified"; usage; exit 1; fi
if [ -z $perm ]; then echo "error: no perm specified"; usage; exit 1; fi

# https://docs.github.com/en/rest/teams/teams?apiVersion=2022-11-28#add-or-update-team-repository-permissions
# pull, triage, push, maintain, admin

if [ "${perm}" = "DELETE" ]; then
    gh api -X DELETE "/orgs/$owner/teams/$team/repos/$owner/$repo"
else
    gh api -X PUT "/orgs/$owner/teams/$team/repos/$owner/$repo" -f "permission=$perm"
fi



# this will list the teams and their perms after the update above
gh api -X GET -H "Accept: application/vnd.github+json"  -H "X-GitHub-Api-Version: 2022-11-28" "/repos/$owner/$repo/teams" | jq '.[] | "\(.name) : \(.permission)"'
