#!/bin/bash
# Author: David Leonard
# This script takes copied X-Men comic listings and turns them into CSV.
# Source Webpage: https://comicpreviews.com/shops/bobs-comics/series/uncanny-x-men-2024
#
# Copy about 12 listings together, starting with an Issue # heading, and save them in a text file. Leave the extra text in place.
#
# Run with a file:
# bash normalize-xmen.sh xmen-source.txt > xmen-normalized.csv
# Or pipe the text into the script:
# cat xmen-source.txt | bash normalize-xmen.sh > xmen-normalized.csv
#
# Each CSV row contains the issue number, title, release date, and price.
# The script uses Bash, sed, and date in Ubuntu.
# It expects each field on its own line and dates written in English.
# It skips blank lines and text it does not recognize (hopefully!).
# Missing information stays blank, and warnings appear in the terminal.

if (( $# > 1 )); then
    printf 'Usage: %s [INPUT.txt]\n' "$0" >&2
    exit 1
fi
if (( $# == 1 )); then
    exec < "$1" || exit 1
fi

# Quote every CSV value and double any quotation marks within it.
csv_field() {
    local value=${1//\"/\"\"}
    printf '"%s"' "$value"
}

emit_record() {
    [[ -z $issue ]] && return
    local normalized_date=''
    if [[ -n $release ]]; then
        normalized_date=$(LC_ALL=C date -d "$release" +%F 2>/dev/null) || {
            printf 'Warning: issue %s has an invalid date: %s\n' "$issue" "$release" >&2
            normalized_date=$release
        }
    fi
    if [[ -z $title || -z $release || -z $price ]]; then
        printf 'Warning: issue %s has missing fields; check the original.\n' "$issue" >&2
    fi
    csv_field "$issue"; printf ','
    csv_field "$title"; printf ','
    csv_field "$normalized_date"; printf ','
    csv_field "$price"; printf '\n'
    records=$((records + 1))
}

issue=''; title=''; release=''; price=''; records=0
printf 'issue_number,title,release_date,price\n'

# Read a line even when the last line has no ending newline.
while IFS= read -r line || [[ -n $line ]]; do
    # Tidy Windows line endings, a possible UTF-8 BOM, and outer whitespace.
    line=${line%$'\r'}
    line=${line#$'\xef\xbb\xbf'}
    line=$(printf '%s' "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    [[ -z $line ]] && continue

    # Stop before the page repeats the comics in other sections.
    [[ $line == 'Reading Order' || $line == 'Publication Timeline' ]] && break

    # Each issue heading starts a record and flushes the preceding record.
    if [[ $line =~ ^Issue[[:space:]]+#([0-9]+)$ ]]; then
        emit_record
        issue=${BASH_REMATCH[1]}
        title=''; release=''; price=''
        continue
    fi
    [[ -z $issue ]] && continue

    if [[ $line =~ ^Uncanny[[:space:]]X-Men[[:space:]]+#([0-9]+) ]]; then
        if [[ ${BASH_REMATCH[1]} == "$issue" ]]; then
            title=$line
        else
            printf 'Warning: title does not match issue %s: %s\n' "$issue" "$line" >&2
        fi
    elif [[ $line == Release:* ]]; then
        release=${line#Release:}
    elif [[ $line =~ ^\$([0-9]+\.[0-9]{2})$ ]]; then
        price=${BASH_REMATCH[1]}
    fi
    # Other text, including View Details, does not belong to these fields.
done
emit_record

if (( records == 0 )); then
    printf 'No records found. Expected headings such as Issue #38.\n' >&2
    exit 1
fi
printf 'Processed %d records.\n' "$records" >&2
