#!/usr/bin/env zsh
#MISE description="Scripted walkthrough of the project-lifecycle features in an isolated tempdir"

# demo.sh — Exercise the mise-wrapper project lifecycle against a throwaway
# projects directory. Safe to re-run; touches nothing under $HOME.
#
# Usage: mise run demo [--keep]
#   --keep   Preserve the tempdir at exit (path is printed)

set -u

KEEP=false
for arg in "$@"; do
    case "$arg" in
        --keep) KEEP=true ;;
        -h|--help)
            cat <<EOF
Usage: mise run demo [--keep]

Walks through list_project_types, mkproject (dry-run + real base),
showproject, lsprojects, workon, cdproject, and rmproject
(archive and --delete) inside an isolated tempdir.

Options:
  --keep   Don't delete the tempdir on exit
EOF
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg" >&2
            exit 2
            ;;
    esac
done

bold=$'\033[1m'; cyan=$'\033[36m'; green=$'\033[32m'
yellow=$'\033[33m'; dim=$'\033[2m'; reset=$'\033[0m'

section() { echo; echo "${bold}${cyan}━━━ $1 ━━━${reset}"; }
step()    { echo; echo "${bold}\$${reset} ${green}$*${reset}"; }
note()    { echo "${dim}# $*${reset}"; }

# ${0:A} resolves the stow symlink back into the dotfiles repo; walk up to root.
DOTFILES=$(git -C "${0:A:h}" rev-parse --show-toplevel 2>/dev/null)
if [[ -z "$DOTFILES" || ! -f "$DOTFILES/lib/misewrapper.sh" ]]; then
    echo "Could not locate dotfiles repo from ${0:A}" >&2
    exit 1
fi
DEMO_ROOT=$(mktemp -d -t dotfiles-demo.XXXXXX)

cleanup() {
    if [[ "$KEEP" == true ]]; then
        echo
        echo "${yellow}Tempdir preserved:${reset} $DEMO_ROOT"
    else
        rm -rf "$DEMO_ROOT"
    fi
}
trap cleanup EXIT

section "Setup"
note "Sourcing lib/misewrapper.sh from $DOTFILES"
source "$DOTFILES/lib/misewrapper.sh"

# Redirect project creation into the tempdir. shared_vars.sh ties PROJECT_DIR
# to $HOME/dev; reassigning MISE_PROJECTS_DIR after sourcing is the narrowest
# override that leaves mise task discovery (via ~/.config/mise/tasks) intact.
MISE_PROJECTS_DIR="$DEMO_ROOT/dev"
mkdir -p "$MISE_PROJECTS_DIR"
note "MISE_PROJECTS_DIR=$MISE_PROJECTS_DIR"

section "1. Discover available project templates"
step "list_project_types"
list_project_types || true

section "2. Dry-run mkproject — preview without side effects"
step "mkproject --dry-run demo-app base"
mkproject --dry-run demo-app base

section "3. Create a base project"
step "mkproject demo-app base"
mkproject demo-app base

section "4. Inspect the project"
step "showproject"
showproject

section "5. Create a second project and list all"
step "mkproject scratchpad base"
mkproject scratchpad base

step "lsprojects"
lsprojects

step "lsprojects --type=created"
lsprojects --type=created

step "lsprojects --tools"
lsprojects --tools

section "6. Switch between projects"
step "workon demo-app"
workon demo-app
echo "${dim}pwd: $PWD${reset}"

step "cdproject  (from a subdirectory)"
mkdir -p "$PWD/src/deep/nested"
cd "$PWD/src/deep/nested"
echo "${dim}moved to: $PWD${reset}"
cdproject
echo "${dim}pwd: $PWD${reset}"

section "7. Archive a project (default behaviour)"
step "rmproject scratchpad"
rmproject scratchpad < /dev/null

step "lsprojects  (note: archive lives in .archive/ and is hidden)"
lsprojects
note "Archive contents:"
ls -1 "$MISE_PROJECTS_DIR/.archive" 2>/dev/null | sed 's/^/  /'

section "8. Permanently delete a project"
step "rmproject demo-app --delete"
rmproject demo-app --delete < /dev/null

step "lsprojects  (empty)"
lsprojects

section "Summary"
cat <<EOF

${bold}Exercised:${reset}
  list_project_types, mkproject (--dry-run and real), showproject,
  lsprojects (default, --type, --tools), workon, cdproject,
  rmproject (archive and --delete).

${bold}Out of scope for this walkthrough:${reset}
  ${dim}cloneproject${reset}    requires network + GitHub auth
  ${dim}updateproject${reset}   requires a cloned project with a live remote
  ${dim}workon -s${reset}       sandbox-exec needs real ~/.ssh + profile
  ${dim}language templates${reset}  (python/ruby/rust/...) install real toolchains
  ${dim}install.sh${reset}      brew bundle + stow touch the real system

To try a language template manually:
  mkproject myapp python     ${dim}# installs uv, creates pyproject.toml${reset}

To demo sandboxing, use a real project:
  workon <name> --sandbox
EOF
