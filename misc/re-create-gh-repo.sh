#!/bin/sh

gh-repo-delete.sh jimweller $i
rm -rf .git
git init
gav .
gcmsg "first"
gh-repo-create-push.sh jimweller $i public
