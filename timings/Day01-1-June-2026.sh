#!/bin/bash

set -e

BRANCH="main"
MONTH="June"
YEAR="2026"

echo "Pulling latest changes..."
git pull origin "$BRANCH"

i=1

find . -maxdepth 1 -type f | \
sort -t'-' -k2,2n | while read file
do
    file=$(basename "$file")

    ext="${file##*.}"

    if [[ "$file" == *.* ]]; then
        new_name=$(printf "Day%02d-%d-%s-%s.%s" "$i" "$i" "$MONTH" "$YEAR" "$ext")
    else
        new_name=$(printf "Day%02d-%d-%s-%s" "$i" "$i" "$MONTH" "$YEAR")
    fi

    if [ "$file" != "$new_name" ]; then
        echo "$file  --->  $new_name"
        git mv "$file" "$new_name"
    fi

    ((i++))
done

git add .

if git diff --cached --quiet; then
    echo "Nothing to commit."
    exit 0
fi

git commit -m "Rename June files sequentially"

git push origin "$BRANCH"

echo "Done!"
