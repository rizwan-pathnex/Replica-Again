#!/bin/bash

set -e

########################################
# Configuration
########################################
BRANCH="main"
MONTH="June"
YEAR="2026"

echo "======================================"
echo "Current Directory: $(pwd)"
echo "======================================"

# Ensure we're inside a Git repository
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    echo "Error: This is not a Git repository."
    exit 1
}

echo
echo "Pulling latest changes..."
git pull origin "$BRANCH"

echo
echo "Renaming files..."

i=1

for file in $(find . -maxdepth 1 -type f -name "*.txt" | sort)
do
    file="${file#./}"
    new_name=$(printf "Day%02d-%d-%s-%s.txt" "$i" "$i" "$MONTH" "$YEAR")

    if [ "$file" != "$new_name" ]; then
        echo "$file  --->  $new_name"
        git mv "$file" "$new_name"
    fi

    ((i++))
done

echo
echo "Adding changes..."
git add .

if git diff --cached --quiet
then
    echo "No changes to commit."
    exit 0
fi

echo
echo "Git Status:"
git status

echo
echo "Committing..."
git commit -m "Rename June timing files sequentially"

echo
echo "Pushing to GitHub..."
git push origin "$BRANCH"

echo
echo "======================================"
echo "SUCCESS!"
echo "======================================"
