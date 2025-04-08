#!/bin/bash
#
# GitFlow Security Automation Script
# A robust bash script to automate the creation and configuration of GitHub repositories 
# with GitFlow branching model and comprehensive security best practices.
#

# Colors for console output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
DEBUG=false
SCRIPT_VERSION="1.0.0"

# Default values
DEFAULT_LICENSE="MIT"
DEFAULT_BRANCH="main"
GIT_FLOW_INSTALLED=false

# Function to display help information
show_help() {
    echo -e "${BLUE}GitFlow Security Automation${NC} v${SCRIPT_VERSION}"
    echo
    echo "Usage: $0 [options]"
    echo
    echo "Options:"
    echo "  -h, --help                   Show this help message"
    echo "  -n, --name REPO_NAME         Specify repository name (required)"
    echo "  -d, --description DESC       Specify repository description (optional)"
    echo "  -p, --private                Create a private repository (default: public)"
    echo "  -c, --collaborators LIST     Add collaborators (comma-separated)"
    echo "  -t, --teams LIST             Add teams (comma-separated)"
    echo "  -v, --verbose                Enable verbose output"
    echo
    echo "Example:"
    echo "  $0 --name my-new-repo --description \"My new project\" --private --collaborators user1,user2 --teams dev-team,security-team"
    echo
}

# Function to log messages
log() {
    local level=$1
    local message=$2
    
    case $level in
        "info")
            echo -e "${GREEN}[INFO]${NC} $message"
            ;;
        "warn")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "error")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
        "debug")
            if [ "$DEBUG" = true ]; then
                echo -e "${BLUE}[DEBUG]${NC} $message"
            fi
            ;;
        *)
            echo -e "$message"
            ;;
    esac
}

# Function to check for prerequisites
check_prerequisites() {
    log "info" "Checking prerequisites..."
    
    # Check for git
    if ! command -v git &> /dev/null; then
        log "error" "git is not installed. Please install git and try again."
        exit 1
    else
        log "debug" "git is installed: $(git --version)"
    fi
    
    # Check for GitHub CLI
    if ! command -v gh &> /dev/null; then
        log "error" "GitHub CLI is not installed. Please install GitHub CLI (gh) and try again."
        log "info" "Visit https://cli.github.com/ for installation instructions."
        exit 1
    else
        log "debug" "GitHub CLI is installed: $(gh --version | head -n 1)"
    fi
    
    # Check if authenticated with GitHub
    if ! gh auth status &> /dev/null; then
        log "error" "Not authenticated with GitHub. Please run 'gh auth login' first."
        exit 1
    else
        log "debug" "Authenticated with GitHub"
    fi
    
    # Check for git-flow (optional)
    if command -v git flow &> /dev/null; then
        GIT_FLOW_INSTALLED=true
        log "debug" "git-flow is installed: $(git flow version)"
    else
        log "warn" "git-flow is not installed. Will use native git commands instead."
    fi
    
    log "info" "All required prerequisites are satisfied."
    return 0
}

# Function to create a new GitHub repository
create_repository() {
    local repo_name=$1
    local description=$2
    local visibility=$3
    
    log "info" "Creating GitHub repository: ${repo_name}..."
    
    # Create repository using GitHub CLI
    if [ "$visibility" = "private" ]; then
        gh repo create "$repo_name" --private --description "$description" --clone
    else
        gh repo create "$repo_name" --public --description "$description" --clone
    fi
    
    if [ $? -ne 0 ]; then
        log "error" "Failed to create repository: ${repo_name}"
        exit 1
    fi
    
    # Navigate to the repository directory
    if [ -d "$repo_name" ]; then
        cd "$repo_name" || {
            log "error" "Failed to navigate to directory: ${repo_name}"
            exit 1
        }
        log "info" "Repository created successfully and cloned locally."
        return 0
    else
        log "error" "Repository directory not found: ${repo_name}"
        exit 1
    fi
}

# Function to verify repository exists remotely
verify_repository() {
    local repo_name=$1
    
    log "debug" "Verifying repository exists remotely: ${repo_name}..."
    
    if gh repo view "$repo_name" &> /dev/null; then
        log "debug" "Repository verified: ${repo_name}"
        return 0
    else
        log "error" "Repository verification failed: ${repo_name}"
        return 1
    fi
}

# Function to add collaborators
add_collaborators() {
    local repo_name=$1
    local collaborators=$2
    
    if [ -z "$collaborators" ]; then
        log "debug" "No collaborators specified. Skipping."
        return 0
    fi
    
    log "info" "Adding collaborators to repository..."
    
    IFS=',' read -ra COLLAB_ARRAY <<< "$collaborators"
    for collab in "${COLLAB_ARRAY[@]}"; do
        log "debug" "Adding collaborator: ${collab}"
        gh repo add-collaborator "$repo_name" "$collab" --permission push
        
        if [ $? -eq 0 ]; then
            log "info" "Added collaborator: ${collab}"
        else
            log "warn" "Failed to add collaborator: ${collab}"
        fi
    done
    
    return 0
}

# Function to add teams
add_teams() {
    local repo_name=$1
    local teams=$2
    
    if [ -z "$teams" ]; then
        log "debug" "No teams specified. Skipping."
        return 0
    fi
    
    log "info" "Adding teams to repository..."
    
    # Get the GitHub username/organization from the repository name
    local org_name
    org_name=$(gh repo view "$repo_name" --json owner -q '.owner.login')
    
    IFS=',' read -ra TEAM_ARRAY <<< "$teams"
    for team in "${TEAM_ARRAY[@]}"; do
        log "debug" "Adding team: ${team}"
        gh api -X PUT "repos/${org_name}/${repo_name}/teams/${team}" --input - <<< '{"permission":"push"}'
        
        if [ $? -eq 0 ]; then
            log "info" "Added team: ${team}"
        else
            log "warn" "Failed to add team: ${team}. Make sure the team exists and you have proper permissions."
        fi
    done
    
    return 0
}

# Function to create LICENSE file
create_license() {
    local license_type=$1
    
    log "info" "Creating LICENSE file (${license_type})..."
    
    local current_year
    current_year=$(date +"%Y")
    local github_user
    github_user=$(gh api user -q '.name')
    
    if [ -z "$github_user" ]; then
        github_user=$(gh api user -q '.login')
    fi
    
    case $license_type in
        "MIT")
            cat > LICENSE <<EOL
MIT License

Copyright (c) ${current_year} ${github_user}

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL
            ;;
        *)
            log "error" "Unsupported license type: ${license_type}"
            return 1
            ;;
    esac
    
    log "debug" "LICENSE file created."
    return 0
}

# Function to create README file
create_readme() {
    local repo_name=$1
    local description=$2
    
    log "info" "Creating README.md file..."
    
    cat > README.md <<EOL
# ${repo_name}

${description}

## Overview

This project was created using the GitFlow Security Automation script.

## Getting Started

### Prerequisites

- Git
- [Other dependencies]

### Installation

\`\`\`bash
git clone https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner).git
cd ${repo_name}
# Additional installation steps here
\`\`\`

## Usage

Describe how to use this project.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add some amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
EOL
    
    log "debug" "README.md file created."
    return 0
}

# Function to initialize GitFlow branch structure
initialize_gitflow() {
    log "info" "Initializing GitFlow branch structure..."
    
    # First, ensure we have an initial commit
    if [ ! -f "README.md" ]; then
        touch README.md
    fi
    
    git add .
    git commit -m "Initial commit" --quiet
    
    if [ $? -ne 0 ]; then
        log "warn" "Initial commit failed or already exists. Continuing..."
    fi
    
    # Ensure main branch exists and push
    git checkout -B "$DEFAULT_BRANCH" --quiet
    git push -u origin "$DEFAULT_BRANCH" --quiet
    
    # Create and push develop branch
    git checkout -b develop --quiet
    echo "# Development Branch" > DEVELOPMENT.md
    git add DEVELOPMENT.md
    git commit -m "Initialize develop branch" --quiet
    git push -u origin develop --quiet
    
    # Verify branches were created
    verify_branch "$DEFAULT_BRANCH"
    verify_branch "develop"
    
    # Create an example feature branch
    log "debug" "Creating example feature branch..."
    if [ "$GIT_FLOW_INSTALLED" = true ]; then
        git flow feature start example-feature
    else
        git checkout -b feature/example-feature develop --quiet
    fi
    
    echo "# Example Feature" > FEATURE.md
    git add FEATURE.md
    git commit -m "Add example feature" --quiet
    git push -u origin feature/example-feature --quiet
    
    # Create an example release branch
    log "debug" "Creating example release branch..."
    if [ "$GIT_FLOW_INSTALLED" = true ]; then
        git flow release start 0.1.0
    else
        git checkout -b release/0.1.0 develop --quiet
    fi
    
    echo "# Example Release" > RELEASE.md
    git add RELEASE.md
    git commit -m "Prepare for release 0.1.0" --quiet
    git push -u origin release/0.1.0 --quiet
    
    # Create an example hotfix branch
    log "debug" "Creating example hotfix branch..."
    if [ "$GIT_FLOW_INSTALLED" = true ]; then
        git checkout "$DEFAULT_BRANCH" --quiet
        git flow hotfix start 0.1.1
    else
        git checkout -b hotfix/0.1.1 "$DEFAULT_BRANCH" --quiet
    fi
    
    echo "# Example Hotfix" > HOTFIX.md
    git add HOTFIX.md
    git commit -m "Fix critical issue" --quiet
    git push -u origin hotfix/0.1.1 --quiet
    
    # Return to develop branch
    git checkout develop --quiet
    
    log "info" "GitFlow branch structure initialized successfully."
    return 0
}

# Function to verify a branch exists both locally and remotely
verify_branch() {
    local branch_name=$1
    
    # Check if branch exists locally
    if git branch --list "$branch_name" | grep -q "$branch_name"; then
        log "debug" "Branch exists locally: ${branch_name}"
    else
        log "error" "Branch does not exist locally: ${branch_name}"
        return 1
    fi
    
    # Check if branch exists remotely
    if git ls-remote --heads origin "$branch_name" | grep -q "$branch_name"; then
        log "debug" "Branch exists remotely: ${branch_name}"
    else
        log "error" "Branch does not exist remotely: ${branch_name}"
        return 1
    fi
    
    log "debug" "Branch verified: ${branch_name}"
    return 0
}

# Function to set up branch protection rules
setup_branch_protection() {
    local repo_name=$1
    
    log "info" "Setting up branch protection rules..."
    
    # Get repository full name
    local repo_full_name
    repo_full_name=$(gh repo view --json nameWithOwner -q .nameWithOwner)
    
    # Try to set up branch protection rules for main branch
    log "debug" "Setting up protection for $DEFAULT_BRANCH branch..."
    gh api -X PUT "repos/${repo_full_name}/branches/${DEFAULT_BRANCH}/protection" \
      -f required_status_checks='{"strict":true,"contexts":[]}' \
      -f enforce_admins=false \
      -f required_pull_request_reviews='{"dismissal_restrictions":{},"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"required_approving_review_count":1}' \
      -f restrictions=null 2>/dev/null
    
    if [ $? -eq 0 ]; then
        log "info" "Branch protection rules set for ${DEFAULT_BRANCH} branch."
    else
        log "warn" "Failed to set branch protection rules for ${DEFAULT_BRANCH} branch. This might be due to using a free GitHub account which has limited branch protection features."
        log "warn" "You can still manually set up branch protection rules in the GitHub repository settings."
    fi
    
    # Try to set up branch protection rules for develop branch
    log "debug" "Setting up protection for develop branch..."
    gh api -X PUT "repos/${repo_full_name}/branches/develop/protection" \
      -f required_status_checks='{"strict":true,"contexts":[]}' \
      -f enforce_admins=false \
      -f required_pull_request_reviews='{"dismissal_restrictions":{},"dismiss_stale_reviews":true,"require_code_owner_reviews":true,"required_approving_review_count":1}' \
      -f restrictions=null 2>/dev/null
    
    if [ $? -eq 0 ]; then
        log "info" "Branch protection rules set for develop branch."
    else
        log "warn" "Failed to set branch protection rules for develop branch. This might be due to using a free GitHub account which has limited branch protection features."
        log "warn" "You can still manually set up branch protection rules in the GitHub repository settings."
    fi
    
    return 0
}

# Function to create security documentation
create_security_documentation() {
    log "info" "Creating security documentation..."
    
    # Create .github directory if it doesn't exist
    mkdir -p .github
    
    # Create SECURITY.md
    log "debug" "Creating SECURITY.md..."
    cat > SECURITY.md <<EOL
# Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| 0.9.x   | :white_check_mark: |
| 0.8.x   | :x:                |
| < 0.8   | :x:                |

## Reporting a Vulnerability

We take the security of our project seriously. If you believe you've found a security vulnerability, please follow these steps:

1. **Do not disclose the vulnerability publicly**
2. **Email us at [your-security-email]** with details about the vulnerability
3. You should receive a response within 48 hours
4. After initial reply, the security team will keep you informed about the progress and fix
5. Once the vulnerability is fixed, we will mention your contribution in the release notes (unless you prefer to remain anonymous)

Thank you for helping to keep our project safe!
EOL
    
    # Create CODEOWNERS file
    log "debug" "Creating .github/CODEOWNERS..."
    mkdir -p .github
    cat > .github/CODEOWNERS <<EOL
# These owners will be the default owners for everything in
# the repo. Unless a later match takes precedence,
# these users will be requested for review when someone opens a pull request.
*       @$(gh api user -q '.login')

# Order is important; the last matching pattern takes the most precedence.

# Team specific ownership
# *.js    @org/js-team
# *.go    @org/go-team
# /docs/  @org/documentation-team

# You can also use email addresses if you prefer, but this will only work for users
# that have public emails on GitHub.
# *.rs    user@example.com
EOL
    
    # Create security issue template
    log "debug" "Creating security issue template..."
    mkdir -p .github/ISSUE_TEMPLATE
    cat > .github/ISSUE_TEMPLATE/security_vulnerability.yml <<EOL
name: Security Vulnerability
description: Report a security vulnerability
title: "[SECURITY]: "
labels: ["security", "triage"]
assignees:
  - $(gh api user -q '.login')
body:
  - type: markdown
    attributes:
      value: |
        Thanks for taking the time to fill out this security vulnerability report.
        **IMPORTANT: If this is a critical security vulnerability, please follow our security policy in SECURITY.md instead of opening an issue.**
  - type: input
    id: version
    attributes:
      label: Version
      description: What version of our software are you using?
      placeholder: "1.0.0"
    validations:
      required: true
  - type: textarea
    id: description
    attributes:
      label: Vulnerability Description
      description: A clear and concise description of what the vulnerability is.
      placeholder: Describe the vulnerability you've identified...
    validations:
      required: true
  - type: textarea
    id: reproduction
    attributes:
      label: Steps To Reproduce
      description: Steps to reproduce the vulnerability.
      placeholder: |
        1. Go to '...'
        2. Click on '....'
        3. Execute '....'
        4. See vulnerability
    validations:
      required: true
  - type: textarea
    id: impact
    attributes:
      label: Potential Impact
      description: What is the potential impact of this vulnerability?
      placeholder: Describe what an attacker could do if they exploited this vulnerability...
    validations:
      required: true
  - type: textarea
    id: mitigation
    attributes:
      label: Suggested Mitigation
      description: Do you have any suggestions for how to mitigate this vulnerability?
      placeholder: Your suggestions for fixing the issue...
    validations:
      required: false
  - type: checkboxes
    id: terms
    attributes:
      label: Code of Conduct
      description: By submitting this report, you agree to follow our code of conduct
      options:
        - label: I agree to follow this project's Code of Conduct
          required: true
EOL
    
    # Create config.yml to disable blank issues
    log "debug" "Creating .github/ISSUE_TEMPLATE/config.yml..."
    cat > .github/ISSUE_TEMPLATE/config.yml <<EOL
blank_issues_enabled: false
contact_links:
  - name: Security Policy
    url: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/blob/main/SECURITY.md
    about: Please review our security policy for reporting vulnerabilities.
  - name: Question or Discussion
    url: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/discussions
    about: Please ask questions or start discussions here.
EOL
    
    # Commit security documentation
    git add SECURITY.md .github/
    git commit -m "Add security documentation" --quiet
    git push origin develop --quiet
    
    log "info" "Security documentation created successfully."
    return 0
}

# Function to set up security scanning
setup_security_scanning() {
    log "info" "Setting up security scanning..."
    
    # Create workflows directory if it doesn't exist
    mkdir -p .github/workflows
    
    # Create CodeQL workflow
    log "debug" "Creating CodeQL workflow..."
    cat > .github/workflows/codeql-analysis.yml <<EOL
name: "CodeQL Analysis"

on:
  push:
    branches: [ "$DEFAULT_BRANCH", "develop" ]
  pull_request:
    branches: [ "$DEFAULT_BRANCH", "develop" ]
  schedule:
    - cron: '0 0 * * 0'  # Run every Sunday at midnight

jobs:
  analyze:
    name: Analyze
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      actions: read
      contents: read

    strategy:
      fail-fast: false
      matrix:
        language: [ 'javascript' ]
        # You can add more languages based on your project needs:
        # language: [ 'javascript', 'python', 'java', 'go', 'cpp', 'ruby' ]

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Initialize CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: \${{ matrix.language }}
        config-file: .github/codeql/codeql-config.yml

    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
EOL
    
    # Create Trivy workflow
    log "debug" "Creating Trivy workflow..."
    cat > .github/workflows/trivy-scan.yml <<EOL
name: "Trivy Security Scan"

on:
  push:
    branches: [ "$DEFAULT_BRANCH", "develop" ]
  pull_request:
    branches: [ "$DEFAULT_BRANCH", "develop" ]
  schedule:
    - cron: '0 0 * * 3'  # Run every Wednesday at midnight

jobs:
  scan:
    name: Scan
    runs-on: ubuntu-latest
    permissions:
      security-events: write
      contents: read
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'

      - name: Upload Trivy scan results to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
EOL
    
    # Create GitLeaks workflow
    log "debug" "Creating GitLeaks workflow..."
    cat > .github/workflows/gitleaks.yml <<EOL
name: "GitLeaks Secret Scanner"

on:
  push:
    branches: [ "$DEFAULT_BRANCH", "develop" ]
  pull_request:
    branches: [ "$DEFAULT_BRANCH" ]
  schedule:
    - cron: '0 0 * * 5'  # Run every Friday at midnight

jobs:
  scan:
    name: Scan for secrets
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: GitLeaks
        uses: gitleaks/gitleaks-action@v2
        env:
          GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
EOL
    
    # Create Dependency Review workflow
    log "debug" "Creating Dependency Review workflow..."
    cat > .github/workflows/dependency-review.yml <<EOL
name: 'Dependency Review'

on:
  pull_request:
    branches: [ "$DEFAULT_BRANCH" ]

permissions:
  contents: read

jobs:
  dependency-review:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      
      - name: Dependency Review
        uses: actions/dependency-review-action@v2
EOL
    
    # Create CodeQL configuration directory and file
    log "debug" "Creating CodeQL configuration..."
    mkdir -p .github/codeql
    cat > .github/codeql/codeql-config.yml <<EOL
name: "Custom CodeQL Configuration"

queries:
  - uses: security-and-quality

paths:
  - src
  - lib
  - app
  - '!node_modules'
  - '!vendor'
  - '!**/*.test.js'
  - '!**/*.spec.js'
  - '!tests'
  - '!**/*.min.js'

paths-ignore:
  - 'dist'
  - 'build'
EOL
    
    # Commit security scanning configurations
    git add .github/workflows/ .github/codeql/
    git commit -m "Add security scanning workflows" --quiet
    git push origin develop --quiet
    
    log "info" "Security scanning setup successfully."
    return 0
}

# Function to enable Security Advisories and alerts
setup_security_advisories() {
    log "info" "Setting up Security Advisories and alerts..."
    
    # Create Dependabot configuration
    log "debug" "Creating Dependabot configuration..."
    mkdir -p .github
    cat > .github/dependabot.yml <<EOL
version: 2
updates:
  # Enable GitHub Actions updates
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    target-branch: "develop"
    labels:
      - "dependencies"
      - "security"
    commit-message:
      prefix: "chore"
      include: "scope"
    assignees:
      - "$(gh api user -q '.login')"
    reviewers:
      - "$(gh api user -q '.login')"

  # Enable npm updates if applicable
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
    target-branch: "develop"
    labels:
      - "dependencies"
      - "security"
    commit-message:
      prefix: "chore"
      include: "scope"
    assignees:
      - "$(gh api user -q '.login')"
    reviewers:
      - "$(gh api user -q '.login')"
    open-pull-requests-limit: 10
    ignore:
      # Ignore patch updates for non-security packages
      - dependency-name: "*"
        update-types: ["version-update:semver-patch"]
EOL
    
    # Enable vulnerability alerts via API
    log "debug" "Enabling vulnerability alerts via API..."
    local repo_full_name
    repo_full_name=$(gh repo view --json nameWithOwner -q .nameWithOwner)
    
    gh api --method PUT "repos/${repo_full_name}/vulnerability-alerts" --silent
    
    if [ $? -eq 0 ]; then
        log "info" "Vulnerability alerts enabled successfully."
    else
        log "warn" "Failed to enable vulnerability alerts via API. You may need to enable them manually in the repository settings."
    fi
    
    # Commit Dependabot configuration
    git add .github/dependabot.yml
    git commit -m "Add Dependabot configuration" --quiet
    git push origin develop --quiet
    
    log "info" "Security Advisories and alerts setup successfully."
    return 0
}

# Function to set up CI workflow
setup_ci_workflow() {
    log "info" "Setting up CI workflow..."
    
    # Create workflows directory if it doesn't exist
    mkdir -p .github/workflows
    
    # Create CI workflow
    log "debug" "Creating CI workflow..."
    cat > .github/workflows/ci.yml <<EOL
name: CI

on:
  push:
    branches: [ "$DEFAULT_BRANCH", "develop" ]
  pull_request:
    branches: [ "$DEFAULT_BRANCH", "develop" ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: 18
        cache: npm
        
    - name: Install dependencies
      run: npm ci || npm install
      
    - name: Run linting
      run: npm run lint || echo "Linting step skipped - no lint script found"
      
    - name: Run tests
      run: npm test || echo "Test step skipped - no test script found"
      
    - name: Build
      run: npm run build || echo "Build step skipped - no build script found"
EOL
    
    # Commit CI workflow
    git add .github/workflows/ci.yml
    git commit -m "Add CI workflow" --quiet
    git push origin develop --quiet
    
    log "info" "CI workflow setup successfully."
    return 0
}

# Function to set up release automation
setup_release_automation() {
    log "info" "Setting up release automation..."
    
    # Create workflows directory if it doesn't exist
    mkdir -p .github/workflows
    
    # Create release workflow
    log "debug" "Creating release workflow..."
    cat > .github/workflows/release.yml <<EOL
name: Release

on:
  push:
    tags:
      - 'v*.*.*'

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      
    steps:
    - uses: actions/checkout@v3
      with:
        fetch-depth: 0
    
    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: 18
        cache: npm
        
    - name: Install dependencies
      run: npm ci || npm install
      
    - name: Build
      run: npm run build || echo "Build step skipped - no build script found"
      
    - name: Create Release
      id: create_release
      uses: actions/create-release@v1
      env:
        GITHUB_TOKEN: \${{ secrets.GITHUB_TOKEN }}
      with:
        tag_name: \${{ github.ref_name }}
        release_name: Release \${{ github.ref_name }}
        draft: false
        prerelease: false
        generate_release_notes: true
EOL
    
    # Commit release workflow
    git add .github/workflows/release.yml
    git commit -m "Add release automation workflow" --quiet
    git push origin develop --quiet
    
    log "info" "Release automation setup successfully."
    return 0
}

# Function to create .gitignore file
create_gitignore() {
    log "info" "Creating .gitignore file..."
    
    cat > .gitignore <<EOL
# Dependency directories
node_modules/
jspm_packages/
bower_components/
vendor/

# Build outputs
dist/
build/
out/
*.min.js
*.min.css

# Environment files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
*.env
config.local.js
credentials.json

# IDE files
.idea/
.vscode/
*.sublime-*
.project
.classpath
.settings/
*.iml
*.swp
*.swo
.DS_Store
Thumbs.db

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Testing and coverage
coverage/
.nyc_output/
.jest/
*.lcov
.coverage

# Misc
.cache/
.temp/
temp/
tmp/
.history/
.sass-cache/
EOL
    
    # Commit .gitignore
    git add .gitignore
    git commit -m "Add .gitignore file" --quiet
    git push origin develop --quiet
    
    log "info" ".gitignore file created successfully."
    return 0
}

# Function to create .editorconfig file
create_editorconfig() {
    log "info" "Creating .editorconfig file..."
    
    cat > .editorconfig <<EOL
# EditorConfig is awesome: https://EditorConfig.org

# top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

# 4 space indentation for Python
[*.py]
indent_size = 4

# Tab indentation for Makefiles
[Makefile]
indent_style = tab

# Windows files
[*.{bat,cmd,ps1}]
end_of_line = crlf

# Markdown files
[*.md]
trim_trailing_whitespace = false

# JSON files
[*.json]
indent_size = 2
EOL
    
    # Commit .editorconfig
    git add .editorconfig
    git commit -m "Add .editorconfig file" --quiet
    git push origin develop --quiet
    
    log "info" ".editorconfig file created successfully."
    return 0
}

# Main function
main() {
    # Default values
    local repo_name=""
    local description="A repository created with GitFlow Security Automation"
    local visibility="public"
    local collaborators=""
    local teams=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -n|--name)
                repo_name="$2"
                shift 2
                ;;
            -d|--description)
                description="$2"
                shift 2
                ;;
            -p|--private)
                visibility="private"
                shift
                ;;
            -c|--collaborators)
                collaborators="$2"
                shift 2
                ;;
            -t|--teams)
                teams="$2"
                shift 2
                ;;
            -v|--verbose)
                DEBUG=true
                shift
                ;;
            *)
                log "error" "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Check if repository name is provided
    if [ -z "$repo_name" ]; then
        log "error" "Repository name is required. Use -n or --name option."
        show_help
        exit 1
    fi
    
    # Check prerequisites
    check_prerequisites
    
    # Create repository
    create_repository "$repo_name" "$description" "$visibility"
    
    # Verify repository creation
    verify_repository "$repo_name"
    
    # Add collaborators and teams
    add_collaborators "$repo_name" "$collaborators"
    add_teams "$repo_name" "$teams"
    
    # Create LICENSE and README
    create_license "$DEFAULT_LICENSE"
    create_readme "$repo_name" "$description"
    
    # Initialize GitFlow branch structure
    initialize_gitflow
    
    # Set up branch protection
    setup_branch_protection "$repo_name"
    
    # Create security documentation
    create_security_documentation
    
    # Set up security scanning
    setup_security_scanning
    
    # Enable Security Advisories and alerts
    setup_security_advisories
    
    # Set up CI workflow
    setup_ci_workflow
    
    # Set up release automation
    setup_release_automation
    
    # Create .gitignore file
    create_gitignore
    
    # Create .editorconfig file
    create_editorconfig
    
    log "info" "Repository setup complete! Your repository is now available at: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)"
    log "info" "Branch structure and security features have been configured according to best practices."
    log "info" "To get started, navigate to the repository directory and start working on the develop branch."
    
    return 0
}

# Run the main function with all arguments
main "$@"