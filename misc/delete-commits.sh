#!/bin/sh

# script to delete all commits from a repo and start fresh
# it's using omyzsh aliases, so you might need to change them to git commands

gsta
git checkout --orphan temp
git add -A
git commit -am "first"
git branch -D main
git branch -m main
git push -f origin main
gstp
gj "cleanup"