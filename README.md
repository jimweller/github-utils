# Git Utilities

This is a collection of scripts and notes about using git and github. Its aim is
to reduce toil and to align with the teams' git standards. It's based on MacOS
and ohmyzsh aliases. So, you might need to do some translation.

- gh-bpr-create.sh - create branch protection rule (opinionated)
- gh-bpr-delete.sh - delete branch protection rule
- gh-bpr-update.sh - update branch protection rule (optionated)
- gh-pr-cycle.sh - Go through a full PR cycle. Pause before merge. Useful for testing github actions.
- gh-repo-create-from-template.sh - Create a new repository from an github template repository
- gh-repo-create-push.sh - Create a new repository from an existing repository. Must init, add, and commit first.
- gh-repo-create.sh - Create a new repository from scratch. Clones after creation.
- gh-repo-delete.sh - Delete a repository
- gh-repo-topics.sh - Add one or more topics to a repository. Useful for categorization for searching and filtering.
- gh-repo-perms-teams.sh - Add/remove team permissions on a repository
- gh-repo-perms-user.sh - Add/remove user permissions on a repository
- gh-tag-advance.sh - Move a tag from one commit to another. Useful for testing release strategies.
- gh-ruleset-export.sh - Export an existing ruleset as json (to stdout)
- gh-ruleset-import.sh - Import a ruleset from a json file to a repository
- gh-ruleset-delete.sh - Remove a ruleset from a repository
- rulesets/ - sample ruleset json files

## Gh Exensions

See also `gh extension` for handy github plugins

```bash
NAME             REPO                      VERSION
gh notify        meiji163/gh-notify        556df2ee
gh open          ream88/gh-open            e30a6172
gh subscription  poretsky/gh-subscription  de6f865c
```

## Jim's Cheat Sheet

(need to cleanup from pandoc conversion)

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

plugins=(git gitignore aliases)

You'll also want to make sure the GPG_TTY variable is set in .zshrc or
signed commits will fail with gpg errors.

export GPG_TTY=\$TTY

### Aliases from OhMyZsh, the most common ones

- **gst** - git status
- **glog** - git log \--oneline \--decorate \--graph
- **grf** - git reflog
- **gcl** {REPO} - git clone
- **gcb** {BRANCH} - git checkout -b
- **gav** - git add \--verbose
- **gc** - git commit \--verbose
- **gcmsg** - git commit \--message {MSG}
- **ggpush** - git push origin {current_branch}
- **grbm** - git rebase \$(git_main_branch)
- **grD** - delete local branch
- **gf** - git fetch
- **grb** - git rebase
- **gco** - git checkout
- **gp** - git push
- **gl** - pit pull

### OMZ Git Aliases, All of them

Use als -g git to see all the git aliases. Make sure you have the omz
aliases plugin enabled. There's 191 of them!

### Setting Visual Studio Code as Your Default Editor

To use vscode with git, edit your .gitconfig

\[core\]

editor = code \--wait

\[mergetool \"vscodemerge\"\]

cmd = code \--wait \$MERGED

\[merge\]

tool = vscodemerge

\[difftool \"vscodediff\"\]

cmd = code \--wait \--diff \$LOCAL \$REMOTE

\[diff\]

tool = vscodediff

To use vscode with github\'s gh cli run

gh config set editor \"code \--wait\"

Then you'll see this set in your \~/.config/gh/config.yml

\# What editor gh should run when creating issues, pull requests, etc.
If blank, will refer to environment.

editor: code \--wait

### Standard GH PR Workflow

This is the standard workflow for working with an existing repository
following the team git standards. Keep all your {text strings} below
lower case.

1. clone a repo

2. create branch

3. DO CODING WORK

4. add files

5. commit

6. fetch

7. rebase

8. checkout

9. push

10. create PR

11. ALL CHECKS PASS and APPROVERS APPROVE

12. Merge PR (and delete PR and local/remote branch)

gcl {REPO}

gcb {type}/{jira-card}-{more-text-description}

\-\--DO SOME CODING\-\--

gav .

gcmsg \"{type}: {message}\"

gf origin main

grb origin/main

gco {type}/{jira-card}-{more-text-description}

git push \--set-upstream origin
{type}/{jira-card}-{other-text-description}

gh pr create -t \"{type}: {jira-card} {more-text-description}\" -T
PULL_REQUEST_TEMPLATE.md

gh pr merge -s -d {type}/{jira-card}-{more-text-description}

- {type} is one of fix, feat or release

- {jira-card} is the name of a card like enbl-304

- {more-text-description} is narrative about what you are doing like
 update thing-one to make thing-two do thing-three

Some of the steps aren't strictly necessary for a simple short lived
task, but running them won't hurt. For example, for example rebasing
when the main branch hasn't changed.

❯ grb origin/main

Current branch fix/enbl-1533-fix-rds-scp-restrictions is up to date.

Note, there is some nuance to deleting PRs and branches at the same
time. There can be github actions that run on PR close events that
expect the branch to still be present. It is generally better to trigger
github actions based on branch behaviors.

### Oops! I Named My Branch Wrong. How do I rename it?

Branches at exampleco follow standards that enable automation. Precise
naming is important. Here's how you can rename a branch both local and
remote.

1. Checkout old branch
2. Rename old to new
3. Push the new branch to remote
4. Delete the old branch from remote

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

gsta

gl

gstp

### Oops! I did my Pull Request Wrong. How do I fix it?

This one is pretty straight forward. You can edit PRs with the gh
command line. Pick the command you need.

gh pr edit \--title new-title

gh pr edit \--body new-body

gh pr edit \--base new-branch

### Creating a new GH repo from a local folder

Change \--private to \--internal or \--public as needed.

1. Make folder

2. git init

3. gh create repo

- Org is probably examplecoSoftware (but might be another org or your
 username as org)

- Repo should be the same name as the foldre

mkdir FOLDER

cd FOLDER

git init

echo \"hello world\" \> README.md

gav .

gcmsg \"first commit\"

gh repo create \--private \--source=. \--remote=origin \--description
\"something something\" \--push ORG/REPO

### Deleting a GH Repo

gh repo delete {repo} \--yes

rm -rf \* .\*

### Generating a .gitignore using the toptal api and gitignore ohmyzsh plugin

gi terraform \> .gitignore

### Switching between git and github accounts (like work and personal)

This assumes you used separate github accounts for work and personal
(vs. having your personal assigned to exampleco groups).

For git, you can use, \[includeif\] clauses in your \~/.gitconfig file.
Then have a personal and work config file that will be selected based on
the working directory.

.gitconfig

\[includeIf \"gitdir:\~/Projects/personal/\"\]

path = \~/.gitconfig-personal

\[includeIf \"gitdir:\~/Projects/work/\"\]

path = \~/.gitconfig-work

.gitconfig-work

\[user\]

name = \"Jim Weller\"

email = jim.weller@exampleco.com

signingkey = 38170000000001072

\[credential \"https://github.com\"\]

username = jim-weller

.gitconfig-personal

\[user\]

name = \"Jim Weller\"

email = jim.weller@domain.com

signingkey = 7E91BDDAC18B0000

\[credential \"https://github.com\"\]

username = jimweller

After you configure the .gitconfig, you'll need to do git init in each
of work and personal . This is just to trick git into using your
identity when in that folder, like for checking out a new repo.

❯ cd \~/Projects/personal

❯ git init

Initialized empty Git repository in
/Users/jim.weller/Projects/personal/.git/

❯ cd \~/Projects/work

❯ git init

Initialized empty Git repository in
/Users/jim.weller/Projects/work/.git/

You can verify your setup with git config.

❯ cd \~/Projects/work

❯ git config \--get user.email

jim.weller@exampleco.com

❯ cd \~/Projects/personal

❯ git config \--get user.email

jweller@personal.com

For gh, you create a subcommand alias that swaps out the hosts.yml file
and authenticates using a gh command. This is in the \~/.config/gh
folder.

host.yml.personal

\[user\]

github.com:

user: jimweller

git_protocol: https

oauth_token: ghp_7ABCDT9mMJIgE0000000000000000000000

hosts.yml.work

github.com:

user: jim-weller

git_protocol: https

oauth_token: ghp_7W9PPT9mMJIgE0000000000000000000000

config.yml

\# Aliases allow you to create nicknames for gh commands

aliases:

personal: \'!cp \~/.config/gh/hosts.yml.personal \~/.config/gh/hosts.yml
&& gh auth status\'

work: \'!cp \~/.config/gh/hosts.yml.work \~/.config/gh/hosts.yml && gh
auth status\'

Now, we switch to a personal account. git will switch by virtue of the
includeif and the directory. gh will switch by running the alias
command.

cd \~/Projects/personal/REPO

gh personal

### Configuring a GH repo the exampleco exampledept way

This configures a repo to match the team git standards. It does not
include the branch protection rule that must be done in the web UI or
with the GH API (see below).

owner=examplecoSoftware

repo=some-github-repo

branch=main

teamtopic=team-cloud-enablement

gh repo edit \\

\--default-branch main \\

\--enable-squash-merge \\

\--enable-merge-commit=false \\

\--enable-rebase-merge=false \\

\--enable-auto-merge=true \\

\--enable-discussions=true \\

\--enable-issues=true \\

\--add-topic \$teamtopic \\

\--enable-wiki=false \\

\--description \"\$owner \$repo \$teamtopic\" \\

\$owner/\$repo

### Github API Wizardry with GraphQL

Get a repository id

owner=examplecoSoftware

repo=tfsandbox

gh api graphql -f
query=\'{repository(owner:\"\'\$owner\'\",name:\"\'\$repo\'\"){id}}\' -q
.data.repository.id

Query
[BranchProtectionRule](https://docs.github.com/en/graphql/reference/objects#branchprotectionrule)s

owner=examplecoSoftware

repo=tfsandbox

gh api graphql -F owner=\${owner} -F repo=\${repo} -f query=\'

query (\$owner: String!, \$repo: String!) {

repository(owner: \$owner, name: \$repo) {

branchProtectionRules(first: 100) {

nodes {

matchingRefs(first: 100) {

nodes {

name

}

}

id

allowsDeletions

allowsForcePushes

blocksCreations

dismissesStaleReviews

isAdminEnforced

lockAllowsFetchAndMerge

lockBranch

pattern

requireLastPushApproval

requiredApprovingReviewCount

requiredDeploymentEnvironments

requiresApprovingReviews

requiresCodeOwnerReviews

requiresCommitSignatures

requiresConversationResolution

requiresDeployments

requiresLinearHistory

requiresStatusChecks

requiresStrictStatusChecks

restrictsPushes

restrictsReviewDismissals

}

}

}

}\'

[CreateBranchProtectionRule](https://docs.github.com/en/graphql/reference/mutations#createbranchprotectionrule)
that matches the team git standards

owner=examplecoSoftware

repo=tfsandbox

repositoryId=\"\$(gh api graphql -f
query=\'{repository(owner:\"\'\$owner\'\",name:\"\'\$repo\'\"){id}}\' -q
.data.repository.id)\"

gh api graphql -f query=\'

mutation(\$repositoryId:ID!,\$branch:String!) {

createBranchProtectionRule(input: {

repositoryId: \$repositoryId

pattern: \$branch

requiresCommitSignatures: true

requiresApprovingReviews: true

dismissesStaleReviews: true

requiresConversationResolution: true

requiresCodeOwnerReviews: true

requiresLinearHistory: true

requireLastPushApproval: true

}) { clientMutationId }

}\' -f repositoryId=\"\$repositoryId\" -f branch=main

Get just the IDs of BranchProtectionRules

owner=examplecoSoftware

repo=tfsandbox

gh api graphql -F owner=\${owner} -F repo=\${repo} -f query=\'

query(\$owner: String!,\$repo: String!){

repository(owner: \$owner, name: \$repo) {

branchProtectionRules(first: 100) {

nodes {

id

}

}

}

}\' -q \'.data.repository.branchProtectionRules.nodes.\[\].id\'

Update a BranchProtectionRule. Here we turn off signed commits (bad!).
You'll need the rule ID from the above example.

ruleid=BPR_kwDOKuu2084CwKHJ

gh api graphql -F ruleid=\$ruleid -f query=\'

mutation( \$ruleid: ID!) {

updateBranchProtectionRule(input:{

branchProtectionRuleId: \$ruleid

requiresCommitSignatures: false }) {

clientMutationId

}

}\'

Delete a BranchProtectionRule.You'll need the rule ID from the above
example.

ruleid=BPR_kwDOKuu2084CwJnS

gh api graphql -F ruleid=\$ruleid -f query=\'

mutation( \$ruleid: ID!) {

deleteBranchProtectionRule(input:{

branchProtectionRuleId: \$ruleid }) {

clientMutationId

}

}\'

### Sample Code

You can see demonstrations of many of the tips and tricks above in the
team's git utilities repository.

<https://github.com/examplecoSoftware/enbl-git-utils>

You can see some github actions to accomplish various pipeline tasks in
the team's collection of demo repositories which are lableled with
\[topic=team-cloud-enablement topic=demo\]

<https://github.com/orgs/examplecoSoftware/repositories?q=topic%3Ateam-cloud-enablement+topic%3Ademo>

### Awesome Actions

Github actions are a way to run various programs in a runner
environment. There is a huge ecosystem of off the shelf actions. And
it's relatively easy to write your own actions.

Here's a list of powerful ones that strongly align with our team's
tooling, standards and practices.

- **actions/checkout** - baseline gh action to checkout a repo for
 other actions in the runner

- **aws-actions/configure-aws-credentials** - establish AWS session
 credentials in the runner

- **hashicorp/setup-terraform** - install terraform in the runner

- **bridgecrewio/yor-action** - automated infrastructure tagging

- **cycjimmy/semantic-release-action** - Use conventional commits to
 automatically generate releases and release tags.

- **wagoid/commitlint-github-action** - assure that git commits adhere
 to standards

- **lekterable/branchlint-action** - assure that branch naming adheres
 to standards

- **amannn/action-semantic-pull-request** - assure pull request naming
 adheres to standards

- **stefanzweifel/git-auto-commit-action** - commit changes from
 within a PR

- **crazy-max/ghaction-import-gpg** - bring a GPG key into the
 workflow to allow an action to do signed commits.

- **fastify/github-action-merge-dependabot** - an action that
 automatically handled the logic for detecting and merging a PR from
 dependabot.

- **github/actions-oidc-debugger** - a way to see the details of a
 JWT. Useful for customizing claimes/subjects when doing AWS+Github
 OIDC.

- **actions/upload-artifact** and **actions/download-artifact** -
 allows you to pass files between workflow steps (like a tfplan from
 tf plan to apply)

- **peter-evans/create-or-update-comment** - add comments to PR's is
 useful to give feedback and to display outputs from workflows

### Links

- <https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification> -
 All the pages about signing commits and managing GPG keys

- <https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits> -
 Sign commits automatically

- <https://gist.github.com/yermulnik/017837c01879ed3c7489cc7cf749ae47> -
 Switching between github profiles

- <https://ohmyz.sh/>

- <https://github.com/romkatv/powerlevel10k>

- <https://www.toptal.com/developers/gitignore>
