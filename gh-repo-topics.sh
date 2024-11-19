#!/bin/sh

# add topics to a repo

OWNER=$1
REPO=$2
TOPIC=$3


usage() { 
    scriptname=`basename $0` 
    echo
    echo "USAGE:" 
    echo "$scriptname ORG REPO topic [topic2] [topic3] ..."
    echo
    echo "Example:"
    echo "$scriptname ExampleOrg example-repo foo bar baz"
}

if [ -z $OWNER ]; then echo "error: no org specified"; usage; exit 1; fi
if [ -z $REPO ]; then echo "error: no repo specified"; usage; exit 1; fi
if [ -z $TOPIC ]; then echo "error: no tpics specified"; usage; exit 1; fi

shift 2  # Shift past the first two arguments to access topics
for TOPIC in "$@"; do
  gh repo edit "$OWNER/$REPO" --add-topic "$TOPIC"
done

