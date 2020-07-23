#!/usr/bin/env bash
source "$(dirname "$0")"/utils.sh

git fetch origin master

differ="git diff $(git merge-base HEAD origin/master)"
changed="$($differ --name-only -- '*.css' '*.js' '*.jsx' '*.md' '*.tsx' '*.ts' '*.json' ':!redirects-list.json' ':!*.test.js')"
code=0

[ -z "$changed" ] && exit 0

echo "$changed" | while read -r file ; do
  # check whole file
  # "$(dirname "$0")"/link-check.sh "$file"
  # check just changed lines
  echo -n "$file:"
  "$(dirname "$0")"/link-check.sh <($differ -U0 -- "$file" | grep '^\+')
  if [ $? -ne 0 ] ; then
     code=1
  fi
done

exit $code
