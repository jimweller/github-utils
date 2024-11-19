#!/bin/sh

# This script will perform a full PR workflow on a repository. It will update
# the changes-a-lot.txt file and then do a branch, pr, and merge. It will
# pause for you too look at the github actions page.

the_serial=$(date +%s)
the_date=`date`


usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname TYPE JIRA SUBJECT MESSAGE"
    echo "OR"
    echo "$scriptname mock"
    echo
    echo "Example:"
    echo "$scriptname fix jira-123 \"fix-that-bug\" \"fix that bug\""
}

if [ $1 == "mock" ]
then
    # What type of change?
    # 
    # https://www.npmjs.com/package/conventional-changelog-eslint
    MY_TYPE="fix"
    # an optional prefix to add to all messaging
    MY_JIRA="jira-1234"
    # branch name
    MY_BRANCH="$MY_TYPE/$MY_JIRA-$the_serial"
    # commit message
    MY_COMMIT_SUBJECT="$MY_TYPE: $MY_JIRA commit message for $the_serial"
    # PR title
    MY_PR_TITLE="$MY_TYPE: $MY_JIRA title for $the_serial"
    #PR body
    MY_PR_BODY="Hello world. Body for branch $MY_BRANCH."
else
    if [ -z $1 ]; then echo "error: no type specified"; usage; exit 1; fi
    if [ -z $2 ]; then echo "error: no jira specified"; usage; exit 1; fi
    if [ -z $3 ]; then echo "error: no subject specified"; usage; exit 1; fi
    if [ -z $4 ]; then echo "error: no message specified"; usage; exit 1; fi


    MY_TYPE=$1
    MY_JIRA=$2
    MY_SUBJ=$3
    MY_MSG=$4
    MY_BRANCH="$MY_TYPE/$MY_JIRA-$MY_SUBJ"
    MY_COMMIT_SUBJECT="$MY_TYPE: $MY_JIRA $MY_MSG"
    MY_PR_TITLE="$MY_TYPE: $MY_JIRA $MY_MSG"
    MY_PR_BODY="$4 for branch $MY_BRANCH."

fi

#set | grep MY_
#exit

# echo
# echo
# echo "-----------------------------------------------------------------------------"
# echo "Check your strings.                                                        --"
# echo "Then, press ENTER if happy, else CTL+C.                                    --"
# echo "-----------------------------------------------------------------------------"
# read


git checkout -b "$MY_BRANCH"

# This is the first commit using a conventional commit message
git add --verbose .
git commit --message "$MY_COMMIT_SUBJECT"

# these are some intermediate commits to show squash merging and semantic release
#for ((i=1;i<=3;i++))
#do
#    date > changes-a-lot.txt && git add --verbose . && git commit --message "non-conventional commit $i"
#done

#git push origin
git push origin $MY_BRANCH

gh pr create --title "$MY_PR_TITLE" --body="$MY_PR_BODY" 


echo
echo
echo "-----------------------------------------------------------------------------"
echo "Go check your PR. Then this script will close it and delte the branch.     --"
echo "Press ENTER when ready.                                                    --"
echo "-----------------------------------------------------------------------------"

read 

gh pr merge "$MY_BRANCH" -s -d


git pull

