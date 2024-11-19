#!/bin/sh

# This is a quick and dirty script to move a tag
# from one commit to another. E.g. fast forward it further downstream.
# It's handy for demo/prototype repos where you don't 
# need the overhead of full semantic versioning.
#
# use git log to find the commit you want to use.


usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname TAG COMMIT_ID"
    echo
    echo "Use git log to find the commit ID you want"
    echo
    echo "Example:"
    echo "$scriptname v1 e687f98b762967c57f55ed90222612692c45859e"
}

tag=$1
commit=$2

if [ -z $tag ]; then echo "error: no tag specified"; usage; exit 1; fi
if [ -z $commit ]; then echo "error: no commit specified"; usage; exit 1; fi


git tag -d $tag        # delete the old tag locally
git push origin :refs/tags/$tag  # delete the old tag remotely
git tag $tag $commit          # make a new tag locally
git push origin $tag             # push the new local tag to the remote 