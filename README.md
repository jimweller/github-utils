# Git Utilities

This is a collection of scripts and notes about using git and github. Its aim is
to reduce toil and to align with a teams' git standards. It's based on
MacOS/Linux and ohmyzsh aliases. So, you might need to do some translation.
Also, note I use HTTPS and not SSH (don't judge), YMMV.

Repository Lifecycle Management

- **gh-repo-create-from-template.sh** - Create a new repository from an github template repository
- **gh-repo-create-push.sh** - Create a new repository from an existing repository. Must init, add, and commit first.
- **gh-repo-create.sh** - Create a new repository from scratch. Clones after creation.
- **gh-repo-delete.sh** - Delete a repository

Repository Editing

- **gh-repo-topics.sh** - Add one or more topics to a repository. Useful for categorization for searching and filtering.
- **gh-repo-perms-teams.sh** - Add/remove team permissions on a repository
- **gh-repo-perms-user.sh** - Add/remove user permissions on a repository
- **gh-tag-advance.sh** - Move a tag from one commit to another. Useful for testing release strategies.

Branch Protection with Rulesets (new)

- **gh-ruleset-export.sh** - Export an existing ruleset as json (to stdout)
- **gh-ruleset-import.sh** - Import a ruleset from a json file to a repository
- **gh-ruleset-delete.sh** - Remove a ruleset from a repository
- **rulesets/** - sample ruleset json files

PR Simulation

- **gh-pr-cycle.sh** - Go through a full PR cycle. Pause before merge. Useful for testing github actions.

Clasic branch protection (deprecated for me)

- **gh-bpr-create.sh** - create branch protection rule (opinionated)
- **gh-bpr-delete.sh** - delete branch protection rule
- **gh-bpr-update.sh** - update branch protection rule (optionated)

## GH Exensions

See also `gh extension` for handy github plugins

```bash
NAME             REPO                      VERSION
gh notify        meiji163/gh-notify        556df2ee
gh open          ream88/gh-open            e30a6172
gh subscription  poretsky/gh-subscription  de6f865c
```

## Cheat Sheet

These are some handy commands and processes for working with git and
github. This assumes you are on a unix command line and
have ohmyzsh, git, gh, and gpg installed and setup on Mac or Linux. It
also assumes you have all the proper github permissions and can
authenticate to github. Windows users can either try to mirror these
ideas in their environment or install WSL (Windows Subsystem for Linux).

### .zshrc

You'll want some ohmyzsh plugins loaded in your .zshrc. You'll likely
have many other plugins. These are just the ones for this document. If
you're not using ohmyzsh and powerlevel10k...then you should be. If you
don't use omz, you'll have to use full commands instead of abbreviated
aliases.

```bash
plugins=(git gitignore aliases jump)
```

You'll also want to make sure the GPG_TTY variable is set in .zshrc or
signed commits will fail with gpg errors.

```bash
export GPG_TTY=$TTY
```

### Aliases from OhMyZsh, the most common ones I use

Use `als -g git` to see all the git aliases. Make sure you have the omz
aliases plugin enabled. There's 191 of them!

- **gst** - git status
- **glog** - git log  --oneline  --decorate  --graph
- **grf** - git reflog
- **gcl** {REPO} - git clone
- **gcb** {BRANCH} - git checkout -b
- **gav** - git add  --verbose
- **gc** - git commit  --verbose
- **gcmsg** - git commit  --message {MSG}
- **ggpush** - git push origin {current_branch}
- **grbm** - git rebase  $(git_main_branch)
- **grD** - delete local branch
- **gf** - git fetch
- **grb** - git rebase
- **gco** - git checkout
- **gp** - git push
- **gl** - pit pull
- **gsta, gstp, gstc** - git stash push, pop, clear
- **grs** - git restore

I have this alias in my `.zshrc` that does add, commit, and push all in one. You
can pass it a message or it will use epoch timestamp when I'm lazy.

```bash
gj () {
  MESSAGE=${1:-"$(date +%s)"}
  git add --verbose . && git commit --message "$MESSAGE" && git push origin "$(git_current_branch)"
}
```

### Setting Visual Studio Code as Your Default Editor

To use vscode with git, edit your .gitconfig

```bash
[core]
  editor = code --wait

[mergetool "vscodeM"]
    cmd = code --wait $MERGED
[merge]
    tool = vscodeM

[difftool "vscodeD"]
    cmd = code --wait --diff $LOCAL $REMOTE
[diff]
    tool = vscodeD

[init]
  defaultBranch = main

[user]
  useConfigOnly=true

[pager]
  branch = false
```

### What editor gh should run when creating commits, issues, pull requests, etc

To use vscode with github's gh cli run

```bash
gh config set editor "code --wait"
```

Then you'll see this set in your ~/.config/gh/config.yml

If blank, will default to EDITOR environmental variable.

```bash
editor: code --wait
```

### Standard GH PR Workflow

This is "normal" trunk based PR workflow for working with an existing repository
following some widespreadS git standards. Keep all your {text strings} below
lower case. There's other branching strategies, but this has been the most
common in workplaces in my experience. Adjust for your type of PR formatting and
merge method.

1. clone a repo
2. create and checkout a branch
3. DO CODING WORK
4. add files
5. commit
6. push
7. create PR
8. (ALL CHECKS PASS and APPROVERS APPROVE)
9. Merge PR (and delete PR and local/remote branch)

```bash
gcl {REPO}
gco -b {type}/{jira-card}-{more-text-description}
---DO SOME CODING---
gav .
gcmsg "{type}: {message}"
ggpush
gh pr create -t "{type}: {jira-card} {more-text-description}" -b "some notes about the PR for the body"
gh pr merge -sd {type}/{jira-card}-{more-text-description}
```

Where

- {type} is one of fix, feat or release
- {jira-card} is the name of a card like enbl-304
- {more-text-description} is narrative about what you are doing like update thing-one to make thing-two do thing-three

Some of the steps aren't strictly necessary for a simple short lived
task, but running them won't hurt. See my `gj` alias for the lazy way.

### Oops! I Named My Branch Wrong. How do I rename it?

Here's how you can rename a branch both local and
remote.

1. Rename old to new
2. Push the new branch to remote
3. Delete the old branch from remote

```bash
git branch -m oldname newname
git push origin :oldname
git push origin newname
```

### Oops! I Named My Commit Wrong. How do I rename it?

This one is hairy. It depends on if it is the last commit or an older
commit. And it depends of if you pushed or not. You'll want to
coordinate with anyone else working on the branch (you are working on a
branch, right!?).

<https://gist.github.com/nepsilon/156387acf9e1e72d48fa35c4fabef0b4#file-git-change-commit-messages-md>

<https://stackoverflow.com/questions/40503417/how-can-i-add-a-file-to-the-last-commit-in-git>

### Oops! I changed my local repo when I was behind the remote. What should I do?

It never hurts to do a git status or git pull when working with other
people or after github actions run. But sometimes you forget.

Most of the time you can stash your changes, pull and then un-stash
them.

```bash
gsta
gl
gstp
```

### Oops! I did my Pull Request Wrong. How do I fix it?

This one is pretty straight forward. You can edit PRs with the gh
command line or UI. Pick the command you need.

```bash
gh pr edit --title new-title
gh pr edit --body new-body
gh pr edit --base new-branch
```

### Generating a .gitignore using the toptal api

This makes generating `.gitignore` files a breeze.
<https://www.toptal.com/developers/gitignore>

I have a function in my `.zshrc` to fetch them with `curl`

```bash
gi () {
  curl -fLw '\n' https://www.toptal.com/developers/gitignore/api/"${(j:,:)@}"
}
```

I always do macos and windows to avoid stupid OS files

```bash
gi macos > .gitignore
gi windows >> .gitignore
gi terraform >> .gitignore
```

### Switching between git and github accounts (like work and personal)

This assumes you use separate github accounts for work and personal (vs. having
your personal assigned to exampleco groups). I encourage that for reasons.

Github made this a lot easier recently. See [gh auth login](https://cli.github.com/manual/gh_auth_login)
and [gh auth switch](https://cli.github.com/manual/gh_auth_switch).

Then I have two aliases to switch identities and working directories fast

```bash
alias work="jump work && gh auth switch --user jim-weller"
alias personal="jump personal && gh auth switch --user jimweller"
```

For git, you can use, `[includeif]` and `[credential]` clauses in your
`~/.gitconfig` file. Then have a personal and work config file that will be
selected based on the working directory.

```bash
[includeIf "gitdir:~/Projects/personal/"]
  path = ~/.gitconfig-personal

[includeIf "gitdir:~/Projects/work/"]
  path = ~/.gitconfig-work

[credential "https://github.com/ExampleCoOrgOne"]
  username = jim-weller

[credential "https://github.com/ExampleCoOrgTwo"]
  username = jim-weller

[credential "https://github.com/jimweller"]
  username = jimweller
```

.gitconfig-personal

```bash
[user]
  name = "Jim Weller"
  email = jim.weller@personal.com
  signingkey = ABCDEF123456

[credential "https://github.com"]
  username = jimweller
```

.gitconfig-work

```bash
[user]
  name = "Jim Weller"
  email = jim.weller@exampleco.com
  signingkey = ABCDEF123456

[credential "https://github.com"]
  username = jim-weller
```

### Awesome Actions

Github actions are a way to run various programs in a runner
environment. There is a huge ecosystem of off the shelf actions. And
it's relatively easy to write your own actions.

- **github** has some good ([off the shelf actions](https://github.com/actions)
- **sdras** has an [amazing list](https://github.com/sdras/awesome-actions)

Here's a list of useful ones that I use often.

- **actions/checkout** - baseline gh action to checkout a repo for
 other actions in the runner
- **aws-actions/configure-aws-credentials** - establish AWS session
 credentials in the runner
- **hashicorp/setup-terraform** - install terraform in the runner
- **opentofu/setup-opentofu** - install opentofu in the runner
- **bridgecrewio/yor-action** - automated infrastructure tagging. It's cool because it can include the git commit hash which makes finding changes a breeze.
- **cycjimmy/semantic-release-action** - Use conventional commits to
 automatically generate releases and release tags.
- **wagoid/commitlint-github-action** - assure that git commits adhere
 to standards
- **lekterable/branchlint-action** - assure that branch naming adheres
 to standards
- **amannn/action-semantic-pull-request** - assure pull request naming
 adheres to standards
- **crazy-max/ghaction-import-gpg** - bring a GPG key into the
 workflow to allow an action to do signed commits.
- **fastify/github-action-merge-dependabot** - an action that
 automatically handles the logic for detecting and merging a PR from
 dependabot.
- **github/actions-oidc-debugger** - a way to see the details of a
 JWT. Useful for customizing claimes/subjects when doing AWS+Github
 OIDC.
- **actions/upload-artifact** and **actions/download-artifact** -
 allows you to pass files between workflow steps (like a tfplan from
 tf plan to apply)
- **peter-evans/create-or-update-comment** - add comments to PR's is
 useful to give feedback and to display outputs from workflows

### Random Links

- <https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification> All the pages about signing commits and managing GPG keys

- <https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits> - Sign commits automatically
