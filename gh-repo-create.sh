#!/bin/sh

# Creates a new repository in the specified organization with the specified name.
# Clones the repository to the current directory.

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
# FLAGS
#       --add-readme             Add a README file to the new repository
#   -c, --clone                  Clone the new repository to the current directory
#   -d, --description string     Description of the repository
#       --disable-issues         Disable issues in the new repository
#       --disable-wiki           Disable wiki in the new repository
#   -g, --gitignore string       Specify a gitignore template for the repository
#   -h, --homepage URL           Repository home page URL
#       --include-all-branches   Include all branches from template repository
#       --internal               Make the new repository internal
#   -l, --license string         Specify an Open Source License for the repository
#       --private                Make the new repository private
#       --public                 Make the new repository public
#       --push                   Push local commits to the new repository
#   -r, --remote string          Specify remote name for the new repository
#   -s, --source string          Specify path to local repository to use as source
#   -t, --team name              The name of the organization team to be granted access
#   -p, --template repository    Make the new repository based on a template repository

gh repo create \
--add-readme \
--description "Created by gh-repo-create.sh $OWNER $REPO $VISIBILITY $@ ($TIMESTAMP)" \
--$VISIBILITY \
--clone \
$OWNER/$REPO

# --source=. \
# --remote=origin \
# --push \



# gh repo edit --help
# FLAGS
#       --add-topic strings        Add repository topic
#       --allow-forking            Allow forking of an organization repository
#       --allow-update-branch      Allow a pull request head branch that is behind its base branch to be updated
#       --default-branch name      Set the default branch name for the repository
#       --delete-branch-on-merge   Delete head branch when pull requests are merged
#   -d, --description string       Description of the repository
#       --enable-auto-merge        Enable auto-merge functionality
#       --enable-discussions       Enable discussions in the repository
#       --enable-issues            Enable issues in the repository
#       --enable-merge-commit      Enable merging pull requests via merge commit
#       --enable-projects          Enable projects in the repository
#       --enable-rebase-merge      Enable merging pull requests via rebase
#       --enable-squash-merge      Enable merging pull requests via squashed commit
#       --enable-wiki              Enable wiki in the repository
#   -h, --homepage URL             Repository home page URL
#       --remove-topic strings     Remove repository topic
#       --template                 Make the repository available as a template repository
#       --visibility string        Change the visibility of the repository to {public,private,internal}

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
