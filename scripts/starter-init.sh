#!/usr/bin/env bash
#
# Turn a fresh clone of the iOS starter into a new project repository.
#
# The starter is used as a TEMPLATE, not a fork: this DELETES the starter's git history, starts a
# new one, and keeps the starter as a separate 'ios-starter' remote. Later starter changes are
# merged in across unrelated histories with scripts/starter-merge.sh.
#
# Usage:
#   git clone https://github.com/allaboutapps/ios-starter.git my-project-ios
#   cd my-project-ios
#   scripts/starter-init.sh [<new-origin-url>]

set -euo pipefail

# shellcheck source=_starter.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_starter.sh"

NEW_ORIGIN="${1:-}"
INIT_BRANCH="${IOS_STARTER_INIT_BRANCH:-main}"

cd "$(repo_root)"

if [ ! -d Modules ] || [ ! -f .swiftlint.yml ]; then
    echo "error: this does not look like an ios-starter clone (no Modules/ or .swiftlint.yml)." >&2
    exit 1
fi

# This script deletes .git. Running it twice would destroy a real project's history, so refuse once
# the repository has already been templated.
if git config "remote.${STARTER_REMOTE}.url" >/dev/null 2>&1; then
    echo "error: this repository already has an '${STARTER_REMOTE}' remote, so it was already initialised." >&2
    echo "       Refusing to delete its history. Use scripts/starter-merge.sh to pull starter changes." >&2
    exit 1
fi

# Recorded in the initial commit so a later merge has a known starting point.
starter_sha="$(git rev-parse HEAD)"
starter_short="$(git rev-parse --short HEAD)"

if [ -n "$(git status --porcelain)" ]; then
    echo "error: working tree is dirty. Start from a clean clone." >&2
    exit 1
fi

echo "This will:"
echo "    - DELETE the starter's git history (.git) in $(pwd)"
echo "    - start a new repository on branch '${INIT_BRANCH}'"
echo "    - commit the current tree as 'Initial commit from ios-starter (${starter_short})'"
echo "    - add the starter as the '${STARTER_REMOTE}' remote (${STARTER_URL})"
if [ -n "$NEW_ORIGIN" ]; then
    echo "    - set 'origin' to ${NEW_ORIGIN}"
else
    echo "    - leave 'origin' unset (pass a URL as the first argument to set it)"
fi
echo
confirm "Are you sure?" || exit 1

rm -rf .git
git init -q -b "$INIT_BRANCH"
git add -A
git commit -q -m "Initial commit from ios-starter (${starter_short})" \
    -m "Templated from ${STARTER_URL} at ${starter_sha}."

git remote add "$STARTER_REMOTE" "$STARTER_URL"
# The starter is upstream-only: pushing a project's commits back to it is never intended.
git remote set-url --push "$STARTER_REMOTE" "no-push-to-the-starter"

if [ -n "$NEW_ORIGIN" ]; then
    git remote add origin "$NEW_ORIGIN"
fi

echo
echo "Done. Next steps:"
echo "    1. Create the app target / Xcode project (this repo intentionally ships none)."
echo "    2. Add the modules you need as local package dependencies, e.g. Modules/CommonUI."
if [ -z "$NEW_ORIGIN" ]; then
    echo "    3. git remote add origin <url> && git push -u origin ${INIT_BRANCH}"
else
    echo "    3. git push -u origin ${INIT_BRANCH}"
fi
echo
echo "Later, to pull starter changes in:"
echo "    scripts/starter-compare.sh    # what changed upstream"
echo "    scripts/starter-merge.sh      # merge it in"
