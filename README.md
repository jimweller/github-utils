# Git Utilities

This is a collection of scripts and notes about using git and github. Its aim is
to reduce toil and to align with the team git standards.

- gh-bpr-create.sh - create branch protection rule (opinionated)
- gh-bpr-delete.sh - delete branch protection rule
- gh-bpr-update.sh - update branch protection rule (optionated)
- gh-pr-cycle.sh - Go through a full PR cycle. Pause before merge. Useful for testing github actions.
- gh-repo-create-from-template.sh - Create a new repository from an github template repository
- gh-repo-create-push.sh - Create a new repository from an existing repository. Must init, add, and commit first.
- gh-repo-create.sh - Create a new  repository from scratch. Clones after creation.
- gh-repo-delete.sh - Delete a repository
- gh-repo-topics.sh - Add one or more topics to a repository. Useful for categorization for searching and filtering.
- gh-repo-perms-teams.sh - Add/remove team permissions on a repository
- gh-repo-perms-user.sh - Add/remove user permissions on a repository
- gh-tag-advance.sh - Move a tag from one commit to another. Useful for testing release strategies.

See also `gh extension` for handy github plugins
