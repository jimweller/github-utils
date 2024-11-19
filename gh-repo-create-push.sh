#!/bin/sh

# Creates a new github repository from an existing local repository.
# Must have done a git init and git add . and git commit -m "initial commit" first.
# Run from inside the local repository.

OWNER=$1
REPO=$2


usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG REPO [visibility] [topic1] [topic2] ..."
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg my-new-repo private topic-foo topic-bar topic-baz"
}


if [ -z $OWNER ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $REPO ]; then echo "error: no repo specified"; usage; exit 1; fi
VISIBILITY=${3:-public}  # Defaults to 'public' if not provided

shift 3  # Shift past the first three arguments to access topics

TIMESTAMP=$(date -u)

# gh repo create --help
gh repo create \
--add-readme \
--description "Created by gh-repo-create.sh $OWNER $REPO $VISIBILITY $@ ($TIMESTAMP)" \
--$VISIBILITY \
--remote=origin \
--source=. \
--push \
$OWNER/$REPO



# gh repo edit --help
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
