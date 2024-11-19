#!/bin/sh



usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG REPO"
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg my-new-repo"
}

owner=$1
repo=$2

if [ -z $owner ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $repo ]; then echo "error: no repo specified"; usage; exit 1; fi


#repositoryId="$(gh api graphql -f query='{repository(owner:"'$owner'",name:"'$repo'"){id}}' -q .data.repository.id)"


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


# Note this is glossing over approvers and code reviews for testing purposes. See gh-bpr-create.sh for details

# https://docs.github.com/en/graphql/reference/input-objects#updatebranchprotectionruleinput
gh api graphql -f query='
mutation($ruleid: ID!) {
  updateBranchProtectionRule(input: {
    branchProtectionRuleId: $ruleid

    allowsDeletions: false
    allowsForcePushes: false
    blocksCreations: false
    bypassForcePushActorIds: []
    bypassPullRequestActorIds: []
    dismissesStaleReviews: true
    isAdminEnforced: true
    lockAllowsFetchAndMerge: false
    lockBranch: false
    pushActorIds: []
    requiredDeploymentEnvironments: []
    requiredStatusCheckContexts: []
    requiredStatusChecks: []
    requiresCommitSignatures: true
    requiresDeployments: false
    requiresLinearHistory: true
    requiresStatusChecks: true
    requiresStrictStatusChecks: true
    restrictsPushes: false
    restrictsReviewDismissals: true
    reviewDismissalActorIds: []

    requiresCodeOwnerReviews: false
    requiresApprovingReviews: true
    requiredApprovingReviewCount: 0
    requiresConversationResolution: false
    requireLastPushApproval: false


  }) { clientMutationId }
}' -F ruleid=$ruleid

