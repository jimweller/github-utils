#!/bin/sh

# DON'T RUN. DON'T RUN!

# This a script Jim Weller used to copy and setup a bunch or repos for FCC SEU team
# It's an example.



# for i in fcc-seu-tenant-inventory fcc-seu-orchestrator fcc-ui fcc-seu-broker fcc-seu-worker
# do
#     git copy https://github.com/ExampleCoDept/ExampleCo.Experience.Blueprint.DotNet.Api https://github.com/ExampleCoDept/$i
# done


# for i in fcc-seu-tenant-inventory fcc-seu-orchestrator fcc-ui fcc-seu-broker fcc-seu-worker
# do
#     gcl https://github.com/ExampleCoDept/$i
#     echo '* @ExampleCoDept/saas-enabled-updates' > $i/.github/CODEOWNERS
#     cd $i
#     gj CODEOWNERS
#     gh browse
#     cd ..
#     gh-repo-perms-team.sh ExampleCoDept $i saas-enabled-updates maintain
#     gh-repo-perms-team.sh ExampleCoDept $i saas-enabled-updates-prod-approvers admin
#     gh-repo-topics.sh ExampleCoDept $i production-deployment team-seu team-fcc
# done

# for i in fcc-seu-worker fcc-seu-worker fcc-ui
# do
#     mkdir $i/.github
#     cp fcc-seu-tenant-inventory/.github/CODEOWNERS $i/.github/
#     cd $i
#     gj CODEOWNERS
#     cd ..
#     gh-repo-perms-team.sh ExampleCoDept $i saas-enabled-updates maintain
#     gh-repo-perms-team.sh ExampleCoDept $i saas-enabled-updates-prod-approvers admin
#     gh-repo-topics.sh ExampleCoDept $i production-deployment team-seu team-fcc
# done

