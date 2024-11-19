#!/bin/sh

# create a branch protection rule that follows team git standards
# also sets all the repo settings

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
if [ -z $branch ]; then echo "error: no branch specified"; usage; exit 1; fi




# docs
# https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
# https://docs.github.com/en/graphql/reference/objects#branchprotectionrule
# https://stackoverflow.com/questions/76384359/github-graphql-api-branch-protection-rule-how-do-i-get-require-a-pull-reque/76422520#76422520

repositoryId="$(gh api graphql -f query='{repository(owner:"'$owner'",name:"'$repo'"){id}}' -q .data.repository.id)"


# note this is glossing over approvers and code reviews for testing purposes

# this would be a more official setting
#    requiresCodeOwnerReviews: true
#    requiresApprovingReviews: true
#    requiredApprovingReviewCount: 1
#    requiresConversationResolution: true
#    requireLastPushApproval: true


# this is a good debug setting. Note the stackoverflow link above about the weirdness with requiresApprovingReviews and requiredApprovingReviewCount
#    requiresCodeOwnerReviews: false
#    requiresApprovingReviews: false
#    requiredApprovingReviewCount: 0
#    requiresConversationResolution: false
#    requireLastPushApproval: false



# https://docs.github.com/en/graphql/reference/input-objects#createbranchprotectionruleinput
gh api graphql -f query='
mutation($repositoryIdQL:ID!,$branchQL:String!) {
  createBranchProtectionRule(input: {
    repositoryId: $repositoryIdQL
    pattern: $branchQL

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
}' -f repositoryIdQL="$repositoryId" -f branchQL=$branch
