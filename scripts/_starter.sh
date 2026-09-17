#!/usr/bin/env bash
#
# Shared configuration for the starter scripts. Sourced, not executed.

STARTER_REMOTE="ios-starter"
STARTER_URL="${IOS_STARTER_URL:-https://github.com/allaboutapps/ios-starter.git}"

# This is the default upstream ios-starter branch used for comparisons.
# You may use a different tag/branch/commit like this:
# - a tag, e.g. `ios-starter-2026-09-16`:  IOS_STARTER_TARGET=ios-starter-2026-09-16
# - a branch, e.g. `mr/housekeeping`:      IOS_STARTER_TARGET=ios-starter/mr/housekeeping   (heads up! it's `ios-starter/<branchname>`)
# - a commit, e.g. `84d8a2b`:              IOS_STARTER_TARGET=84d8a2b
STARTER_TARGET="${IOS_STARTER_TARGET:-ios-starter/main}"

repo_root() {
    git rev-parse --show-toplevel 2>/dev/null || {
        echo "error: not inside a git repository" >&2
        exit 1
    }
}

# Idempotent: adds the remote only when it is not configured yet.
ensure_starter_remote() {
    git config "remote.${STARTER_REMOTE}.url" >/dev/null 2>&1 ||
        git remote add "$STARTER_REMOTE" "$STARTER_URL"
}

fetch_starter() {
    echo "IOS_STARTER_TARGET=${STARTER_TARGET}"
    ensure_starter_remote

    # Fetch branches *and* tags in one go. Fetching a single ref by name would only write it to
    # FETCH_HEAD, leaving a tag or commit target unresolvable as a revision below.
    git fetch --tags "$STARTER_REMOTE"

    if ! git rev-parse --verify --quiet "${STARTER_TARGET}^{commit}" >/dev/null; then
        echo "error: '${STARTER_TARGET}' does not resolve to a commit." >&2
        echo "       Expected a remote branch (ios-starter/<branch>), a tag, or a commit sha." >&2
        exit 1
    fi
}

confirm() {
    local prompt="$1"
    printf '%s [y/N] ' "$prompt"
    local answer
    read -r answer
    [ "${answer:-N}" = "y" ] || [ "${answer:-N}" = "Y" ]
}
