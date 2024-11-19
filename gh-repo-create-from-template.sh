#!/bin/sh

# Creates a new repository in the specified organization with the specified name from the specified template
# Clones the repository to the current directory.

OWNER=$1
REPO=$2
TEMPLATE=$3


usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG REPO TEMPLATE [visibility] [topic1] [topic2] ..."
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg my-new-repo private topic-foo topic-bar topic-baz"
}


if [ -z $OWNER ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $REPO ]; then echo "error: no repo specified"; usage; exit 1; fi
if [ -z $TEMPLATE ]; then echo "error: no repo specified"; usage; exit 1; fi
VISIBILITY=${4:-public}  # Defaults to 'public' if not provided

shift 4  # Shift past the first thrfouree arguments to access topics

TIMESTAMP=$(date -u)

# gh repo create --help
gh repo create \
--description "\"Created by gh-repo-create.sh $OWNER $REPO $VISIBILITY $@ Template: $TEMPLATE ($TIMESTAMP)\"" \
--$VISIBILITY \
--clone \
--template $TEMPLATE \
$OWNER/$REPO


gh repo edit \
--allow-update-branch=true  \
--delete-branch-on-merge=true \
--enable-auto-merge=true \
--enable-discussions=false \
--enable-issues=true \
--enable-merge-commit=false \
--enable-projects=false \
--enable-rebase-merge=false \
--enable-squash-merge=true \
--enable-wiki=false \
$OWNER/$REPO


for TOPIC in "$@"; do
  gh repo edit "$OWNER/$REPO" --add-topic "$TOPIC"
done










# notes from earlier
# if forking is disabled at org then it errors out duplicating it
#--allow-forking=false \
#
# default branch is already main at org level and errors out repeating it
#--default-branch main \
#branch=main
