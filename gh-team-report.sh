#!/bin/bash

ORG="HylandExperience"
PRINT_USERS=false

usage() {
    scriptname=$(basename "$0")
    echo
    echo "USAGE:"
    echo "$scriptname [-u] TEAM_SLUG"
    echo
    echo "Options:"
    echo "  -u    Print users in each team"
    echo
    echo "Example:"
    echo "$scriptname federated-content-cloud"
    echo "$scriptname -u federated-content-cloud"
}

while getopts ":u" opt; do
    case $opt in
        u) PRINT_USERS=true ;;
        \?) echo "Invalid option: -$OPTARG"; usage; exit 1 ;;
    esac
done
shift $((OPTIND -1))

ROOT_TEAM_SLUG="$1"

if [ -z "$ROOT_TEAM_SLUG" ]; then
    echo "error: no team slug specified"
    usage
    exit 1
fi

function fetch_team_members() {
    local team_slug=$1
    gh api "/orgs/$ORG/teams/$team_slug/members" --jq '.[].login' 2>/dev/null
}

function fetch_child_teams() {
    local parent_team_slug=$1
    gh api "/orgs/$ORG/teams/$parent_team_slug/teams" --jq '.[].slug' 2>/dev/null
}

function print_team_tree() {
    local team_slug=$1
    local prefix=$2
    local is_last=$3
    local is_root=$4

    local branch="├──"
    local continuation="│   "
    local last_branch="└──"

    if [ "$is_root" = true ]; then
        echo "$team_slug"
    else
        if [ "$is_last" = true ]; then
            echo "${prefix}${last_branch} ${team_slug}"
            prefix="${prefix}    "
        else
            echo "${prefix}${branch} ${team_slug}"
            prefix="${prefix}${continuation}"
        fi
    fi

    local children=($(fetch_child_teams "$team_slug"))
    local child_count=${#children[@]}

    if $PRINT_USERS; then
        local members=($(fetch_team_members "$team_slug"))
        local member_count=${#members[@]}
        for i in "${!members[@]}"; do
            if [ $((i + 1)) -eq "$member_count" ] && [ "$child_count" -eq 0 ]; then
                echo "${prefix}└── ${members[$i]}"
            else
                echo "${prefix}├── ${members[$i]}"
            fi
        done
    fi

    for i in "${!children[@]}"; do
        local last_child=false
        if [ $((i + 1)) -eq "$child_count" ]; then
            last_child=true
        fi
        print_team_tree "${children[$i]}" "$prefix" "$last_child" false
    done
}

print_team_tree "$ROOT_TEAM_SLUG" "" false true
