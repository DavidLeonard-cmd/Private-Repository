#!/usr/bin/env bash
# Author: David Leonard
# Replaces the separators between fields and prints every line.
# Run with: bash ReplaceDelimiters_awk.sh '[[:blank:]]*:[[:blank:]]*' < People.txt
# This finds colons and any spaces or tabs around them (the amount of trash data I get at work with this issue is INSANE!)

if [[ $# -lt 1 || $# -gt 2 || -z $1 ]]; then
    echo "Run with: bash ReplaceDelimiters_awk.sh PATTERN [REPLACEMENT] < People.txt" >&2
    exit 2
fi

pattern=$1
# Use a comma and a space if no replacement was given.
replacement=${2-', '}
if [[ $pattern == *[$'\r\n']* || $replacement == *[$'\r\n']* ]]; then
    echo 'Keep the pattern and replacement on one line.' >&2
    exit 2
fi

# Tell awk to print backslashes and ampersands as typed.
replacement=${replacement//\\/'\\'}
replacement=${replacement//&/'\&'}

# Export these settings so awk can read them.
export DELIMITER_PATTERN="$pattern"
export DELIMITER_REPLACEMENT="$replacement"

awk '
    BEGIN {
        pattern = ENVIRON["DELIMITER_PATTERN"]
        replacement = ENVIRON["DELIMITER_REPLACEMENT"]
    }
    {
        # gsub replaces every match. $0 is the whole line.
        gsub(pattern, replacement, $0)
        print $0
    }
    '
