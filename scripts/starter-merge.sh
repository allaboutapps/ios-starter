#!/usr/bin/env bash
#
# Merge the upstream starter into the current HEAD.
#
# The starter is a template, not a fork, so a project's history is unrelated to it — hence
# --allow-unrelated-histories. The merge is left uncommitted and conflicts are left in the working
# tree on purpose: review them, resolve, then commit yourself.
#
# Usage:
#   scripts/starter-merge.sh
#   IOS_STARTER_TARGET=ios-starter/some-branch scripts/starter-merge.sh

set -euo pipefail

# shellcheck source=_starter.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_starter.sh"

cd "$(repo_root)"

if [ -n "$(git status --porcelain)" ]; then
    echo "error: working tree is dirty. Commit or stash your changes before merging." >&2
    exit 1
fi

"$(dirname "${BASH_SOURCE[0]}")/starter-compare.sh"

echo
echo "Attempting to execute 'git merge --no-commit --no-ff --allow-unrelated-histories ${STARTER_TARGET}' into your current HEAD."
confirm "Are you sure?" || exit 1

# `|| true`: a conflicting merge is the normal case, and the conflicts must survive for you to fix.
git merge --no-commit --no-ff --allow-unrelated-histories "${STARTER_TARGET}" || true

conflicts="$(git diff --name-only --diff-filter=U)"

echo
if [ -n "$conflicts" ]; then
    echo "Conflicts to resolve:"
    echo "$conflicts" | sed 's/^/    /'
    echo
    echo "Resolve them, then: git add <files> && git commit"
else
    echo "Merged cleanly, nothing committed yet. Review with 'git diff --cached', then: git commit"
fi

echo
echo "Afterwards, verify the result:"
echo "    swiftformat . && swiftlint lint --strict"
echo "    cd Modules/<Name> && xcodebuild test -scheme <Name> -destination '<simulator>'"
