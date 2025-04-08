#!/bin/bash

set -e

# === Color Constants ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# === Logging Helpers ===
log_success() { echo -e "${GREEN}[✔] $1${NC}"; }
log_error() { echo -e "${RED}[✖] $1${NC}"; }
log_info() { echo -e "${YELLOW}[➤] $1${NC}"; }

# === Check prerequisites ===
check_prerequisites() {
  log_info "Checking prerequisites..."
  command -v git >/dev/null 2>&1 || { log_error "Git is not installed"; exit 1; }
  command -v gh >/dev/null 2>&1 || { log_error "GitHub CLI is not installed"; exit 1; }
  log_success "All prerequisites met"
}

# === Create GitHub repository ===
create_repository() {
  local REPO_NAME="$1"
  local REPO_DESC="$2"
  local VISIBILITY="$3"  # public or private

  log_info "Creating GitHub repository: $REPO_NAME"

  if gh repo view "$REPO_NAME" >/dev/null 2>&1; then
    log_error "Repository $REPO_NAME already exists."
    exit 2
  fi

  gh repo create "$REPO_NAME" --$VISIBILITY --description "$REPO_DESC" --confirm || {
    log_error "Failed to create repository"
    exit 3
  }
  log_success "Repository created successfully"

  git clone "https://github.com/$(gh api user | jq -r '.login')/$REPO_NAME.git" || {
    log_error "Failed to clone repository"
    exit 4
  }
  cd "$REPO_NAME"
  log_success "Repository cloned and switched to directory: $REPO_NAME"
}

# === Initialize README and LICENSE ===
initialize_docs() {
  local PROJECT_NAME="$1"
  local DESCRIPTION="$2"

  log_info "Initializing documentation files..."

  echo "# $PROJECT_NAME" > README.md
  echo "$DESCRIPTION" >> README.md

  YEAR=$(date +%Y)
  echo "MIT License" > LICENSE
  echo "Copyright (c) $YEAR $(gh api user | jq -r '.name')" >> LICENSE

  git add README.md LICENSE
  git commit -m "Add README and LICENSE"
  git push origin main

  log_success "Documentation initialized and pushed"
}

# === MAIN EXECUTION ===
main() {
  check_prerequisites
  
  REPO_NAME="$1"
  REPO_DESC="$2"
  VISIBILITY="$3"

  if [[ -z "$REPO_NAME" || -z "$REPO_DESC" || -z "$VISIBILITY" ]]; then
    log_error "Usage: $0 <repo-name> <description> <public|private>"
    exit 9
  fi

  create_repository "$REPO_NAME" "$REPO_DESC" "$VISIBILITY"
  initialize_docs "$REPO_NAME" "$REPO_DESC"
}

main "$@"
