---
name: starter-sync
description: Run the iOS starter sync workflow — create a project from the starter template, see what changed upstream, merge starter changes in, and resolve the mechanical conflicts. Invoke explicitly; this performs git operations.
disable-model-invocation: true
argument-hint: "[init | compare | merge]"
allowed-tools: Bash(scripts/starter-*.sh *), Bash(git *), Bash(swiftlint *), Bash(swiftformat *), Bash(xcodebuild *), Bash(xcrun *), Read, Edit, Write, Grep, Glob
---

# Starter sync

Drives `scripts/starter-*.sh`. The starter is a **template, not a fork**: the first merge joins two
unrelated histories (hence `--allow-unrelated-histories`, which the script always passes). Later
merges share a common ancestor and are ordinary three-way merges — usually small.

Requested operation: **$ARGUMENTS** (if empty, ask which one, or infer it from the checks below).

## Pick the operation

| Situation | Script |
|---|---|
| Fresh clone of the starter that should become a new project | `scripts/starter-init.sh [<origin-url>]` |
| Existing project that was never based on the starter (e.g. raika) | `/ios-starter-connect` (from the `ios@aaa-marketplace` plugin — this repo's scripts are not there yet) |
| Connected project: what changed upstream? | `scripts/starter-compare.sh` |
| Connected project: bring the changes in | `scripts/starter-merge.sh` |

Decide with:

```sh
git config remote.ios-starter.url    # set => already connected, use compare/merge
git log --oneline -1                 # "Initial commit from ios-starter (<sha>)" => came from the template
```

Target a branch, tag or commit other than `ios-starter/main` with `IOS_STARTER_TARGET`:

```sh
IOS_STARTER_TARGET=ios-starter/some-branch scripts/starter-compare.sh
IOS_STARTER_TARGET=ios-starter-2026-09-16 scripts/starter-compare.sh
IOS_STARTER_TARGET=84d8a2b scripts/starter-compare.sh
```

## Rules

- **Never run these with a dirty working tree.** `starter-init.sh` deletes `.git`; the others
  refuse outright. Commit or stash first.
- **Never `git add -A && git commit` a merge blind.** The merge is deliberately left uncommitted so
  the result is reviewed before it becomes history.
- **Never push to the `ios-starter` remote.** Its push URL is disabled on purpose. Changes that
  every project should get are made *in the starter* and merged outward.
- `starter-init.sh` refuses to run twice (it checks for the `ios-starter` remote) — don't work
  around that guard, it is what stops a real project's history being deleted.

## Resolving the merge

Conflicts are the normal case: a project that customized a file the starter also changed *should*
collide. Resolve the mechanical ones yourself; leave the judgement calls for the developer.

The guiding rule: **the project's content is specific, the starter's content is general.** Where
both can coexist, combine them — keep the project's specifics and add the starter's baseline. Where
they genuinely conflict in meaning, **the project's version wins** and the file stays for a human.

Get the list with `git diff --name-only --diff-filter=U`, then work file by file:

| File | What to do |
|---|---|
| `.swiftlint.yml`, `.swiftformat`, `.gitignore` | **Combine.** Take the starter's new baseline rules, then re-apply every project-specific `excluded:` path, custom rule and threshold. Never drop a project exclusion — it is there because something in that repo needs it. |
| `.swift-version` | Take the starter's, unless the project pins a different Swift version on purpose. |
| `scripts/_starter.sh`, `scripts/starter-*.sh` | Take the starter's wholesale — this is the starter's own tooling. |
| `.claude/settings.json` | **Combine** the JSON: union `enabledPlugins` and `extraKnownMarketplaces`. |
| `.claude/skills/**` | Take the starter's, then correct any statement that is false for this project (module list, whether an `.xcodeproj` is committed). |
| `.github/workflows/**` | **Combine.** Take the starter's step improvements; keep the project's `matrix.module` list and any project-specific steps. |
| `Modules/Toolbox/**`, `Modules/CommonUI/**` *(starter-owned, project never forked them)* | Take the starter's. |
| `README.md` | Keep the project's. |
| A starter-owned module the project **has** edited locally | **Stop.** The local edit belongs upstream in the starter, not here. Leave conflicted and say so. |
| A module whose name the project also uses for its own (e.g. its own `CommonUI`) | **Stop.** Two different modules share a name; only a human decides which the app builds against. |
| `*.swift` in project code, `project.yml`, `*.pbxproj`, anything else | **Stop.** Leave conflicted. |

For each file you resolve, write the merged content and `git add` it. For each file you leave, say
which decision it needs.

Never resolve by deleting content from either side to make the markers go away. When unsure, leave
it conflicted — an unresolved conflict costs a developer minutes, a wrongly resolved one costs far
more.

## Verify, then hand back

```sh
swiftformat --lint . && swiftlint lint --strict
cd Modules/<Name> && xcodebuild test -scheme <Name> -destination 'id=<simulator-udid>'
```

Resolve a simulator udid from `xcrun simctl list devices available` — `name=…,OS=latest` fails
whenever the newest runtime does not ship that exact device.

Then report:

- what came in cleanly,
- what you resolved and how,
- what is **still conflicted** and the decision each one needs,
- the undo command: `git merge --abort`.

Leave the merge uncommitted. The developer commits — never `--no-verify`.

## First adoption of an existing project

Adoption is handled by the `/ios-starter-connect` skill in the `ios@aaa-marketplace` plugin, not
from here: a project that is not connected yet has no copy of these scripts. It applies the same
resolution rules as above, on a dedicated `adopt-ios-starter` branch.

The first adoption is the expensive one — unrelated histories mean every shared file collides as
add/add, whole file against whole file. Afterwards the project uses the scripts here and the
conflicts shrink to ordinary three-way ones.
