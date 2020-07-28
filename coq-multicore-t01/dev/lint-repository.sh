#!/usr/bin/env bash

# A script to check prettyness over the repository.

# lint-commits.sh seeks to prevent the worsening of already present
# problems, such as tab indentation in ml files. lint-repository.sh
# also seeks to prevent the (re-)introduction of solved problems, such
# as newlines at the end of .v files.

CODE=0

if [[ $(git log -n 1 --pretty='format:%s') == "Bot merge"* ]]; then
    # The FIRST parent of bot merges is from the PR, the second is
    # current master
    head=$(git rev-parse HEAD~)
else
    head=$(git rev-parse HEAD)
fi

# We assume that all non-bot merge commits are from the main branch
# For Coq it is extremely rare for this assumption to be broken
read -r base < <(git log -n 1 --merges --pretty='format:%H' "$head")

dev/lint-commits.sh "$base" "$head" || CODE=1

# Check that the files with 'whitespace' gitattribute end in a newline.
# xargs exit status is 123 if any file failed the test
echo Checking end of file newlines
find . "(" -path ./.git -prune ")" -o -type f -print0 |
    xargs -0 dev/tools/check-eof-newline.sh || CODE=1

echo Checking overlays
dev/tools/check-overlays.sh || CODE=1

echo Checking ocamlformat
make -f Makefile.dune fmt || CODE=1

exit $CODE
