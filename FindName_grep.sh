#!/usr/bin/env bash
# Author: David Leonard
# Finds a name in the list and prints each matching line.
# Run with: bash FindName_grep.sh 'Ororo Munroe' < People.txt

# $1 is the name to look for. Put names with spaces in quotes.
if [[ $# -ne 1 || -z $1 || $1 == *$'\n'* ]]; then
    echo "Run with: bash FindName_grep.sh 'Ororo Munroe' < People.txt" >&2
    exit 2
fi

# -F tells grep to look for the name exactly as typed.
grep -F -e "$1"
