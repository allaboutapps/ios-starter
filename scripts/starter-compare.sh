#!/usr/bin/env bash
#
# Compare the upstream starter to HEAD: how many commits behind, and which ones.
#
# Usage:
#   scripts/starter-compare.sh
#   IOS_STARTER_TARGET=ios-starter/some-branch scripts/starter-compare.sh

set -euo pipefail

# shellcheck source=_starter.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/_starter.sh"

cd "$(repo_root)"
fetch_starter

echo
echo "Commits away from upstream ${STARTER_TARGET}:"
git --no-pager rev-list --left-only --count "${STARTER_TARGET}...HEAD"

echo
echo "Git log:"
git --no-pager log --left-only \
    --pretty="%C(Yellow)%h  %C(reset)%ad (%C(Green)%cr%C(reset))%x09 %C(Cyan)%an: %C(reset)%s" \
    --abbrev-commit "${STARTER_TARGET}...HEAD"
