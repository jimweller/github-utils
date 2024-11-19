#!/bin/sh

# add a team to a repo with a specific permission

owner=$1
repo=$2
user=$3
perm=$4


usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG REPO USER PERMISSION"
    echo
    echo "permissions are one of DELETE, pull, triage, push, maintain, admin"
    echo
    echo If permission is not specified, the user will be removed as a repo collaborator.
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg my-new-repo jfoster-example maintain"
}


if [ -z $owner ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $repo ]; then echo "error: no repo specified"; usage; exit 1; fi
if [ -z $user ]; then echo "error: no user specified"; usage; exit 1; fi
if [ -z $perm ]; then echo "error: no perm specified"; usage; exit 1; fi

# https://docs.github.com/en/rest/teams/teams?apiVersion=2022-11-28#add-or-update-team-repository-permissions
# pull, triage, push, maintain, admin

if [ "${perm}" = "DELETE" ]; then
    gh api -X DELETE "/repos/$owner/$repo/collaborators/$user"
else
    gh api -X PUT "/repos/$owner/$repo/collaborators/$user" -f "permission=$perm"
fi


# this will list the users and their perms after the update above
# https://docs.github.com/en/rest/collaborators/collaborators?apiVersion=2022-11-28#list-repository-collaborators
gh api -X GET -H "Accept: application/vnd.github+json"  -H "X-GitHub-Api-Version: 2022-11-28" "/repos/$owner/$repo/collaborators"  -f "affiliation=direct" | jq '.[] | "\(.login) : \(.role_name)"'