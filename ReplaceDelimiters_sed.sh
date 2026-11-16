#!/usr/bin/env bash
# Author: David Leonard
# Replaces the separators between fields and prints every line.
# Run with: bash ReplaceDelimiters_sed.sh '[[:blank:]]*:[[:blank:]]*' < People.txt
# This finds colons and any spaces or tabs around them (the amount of trash data I get at work with this issue is INSANE!)

if [[ $# -lt 1 || $# -gt 2 || -z $1 ]]; then
    echo "Run with: bash ReplaceDelimiters_sed.sh PATTERN [REPLACEMENT] < People.txt" >&2
    exit 2
fi

pattern=$1
# Use a comma and a space if no replacement was given.
replacement=${2-', '}

# Use a rarely typed character to split up the parts of the sed command.
separator=$'\x1f'
if [[ $pattern == *[$'\r\n\x1f']* || $replacement == *[$'\r\n']* ]]; then
    echo 'Keep the pattern and replacement on one line.' >&2
    exit 2
fi

# Have sed to print these special characters as typed.
replacement=${replacement//\\/'\\'}
replacement=${replacement//&/'\&'}
replacement=${replacement//"$separator"/"\\$separator"}

# s means substitute. g means replace every match on the line.
sed -E "s${separator}${pattern}${separator}${replacement}${separator}g"
