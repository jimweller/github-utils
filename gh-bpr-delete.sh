#!/bin/sh

owner=$1
repo=$2



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




#repositoryId="$(gh api graphql -f query='{repository(owner:"'$owner'",name:"'$repo'"){id}}' -q .data.repository.id)"


# https://docs.github.com/en/graphql/reference/objects#repository
ruleid=$(gh api graphql -F owner=${owner} -F repo=${repo} -f query='
  query ($owner: String!, $repo: String!) {
    repository(owner: $owner, name: $repo) {
      branchProtectionRules(first: 100) {
        nodes {
          matchingRefs(first: 100) {
            nodes {
              name
            }
          }
          id
        }
      }
    }
  }' -q  '.data.repository.branchProtectionRules.nodes.[].id')


# https://docs.github.com/en/graphql/reference/input-objects#deletebranchprotectionruleinput
gh api graphql -f query='
mutation( $ruleid: ID!) {
  deleteBranchProtectionRule(input:{
    branchProtectionRuleId: $ruleid }) {
    clientMutationId
    }
}' -F ruleid=$ruleid 

