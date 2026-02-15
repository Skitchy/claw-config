#!/bin/bash
# deploy.sh — Claw Ecosystem GitOps Deploy Script
# Runs via cron every 5 minutes on VPS
# Polls GitHub repos for changes and syncs to OpenClaw workspace
#
# Usage: Add to crontab:
#   */5 * * * * /home/skitch/.openclaw/deploy.sh >> /home/skitch/.openclaw/deploy.log 2>&1

set -euo pipefail

OPENCLAW_HOME="${HOME}/.openclaw"
WORKSPACE="${OPENCLAW_HOME}/workspace"
SKILLS_DIR="${WORKSPACE}/skills"
REPOS_DIR="${OPENCLAW_HOME}/repos"
LOG_PREFIX="[$(date -u +%Y-%m-%dT%H:%M:%SZ)]"

# Ensure directories exist
mkdir -p "$REPOS_DIR" "$SKILLS_DIR"

log() {
    echo "${LOG_PREFIX} $1"
}

# Sync a single skill repo
sync_skill() {
    local repo_name="$1"
    local repo_url="$2"
    local skill_name="$3"
    local repo_path="${REPOS_DIR}/${repo_name}"

    # Clone if not present
    if [ ! -d "$repo_path" ]; then
        log "Cloning ${repo_name} for the first time..."
        git clone --quiet "$repo_url" "$repo_path"
        cp -r "${repo_path}/" "${SKILLS_DIR}/${skill_name}/"
        log "Installed skill: ${skill_name}"
        return
    fi

    # Fetch and check for changes
    cd "$repo_path"
    git fetch --quiet origin main 2>/dev/null || git fetch --quiet origin master 2>/dev/null || {
        log "WARNING: Could not fetch ${repo_name}"
        return
    }

    local LOCAL_HEAD=$(git rev-parse HEAD)
    local REMOTE_HEAD=$(git rev-parse FETCH_HEAD)

    if [ "$LOCAL_HEAD" = "$REMOTE_HEAD" ]; then
        return  # No changes, silent
    fi

    log "Changes detected in ${repo_name}: ${LOCAL_HEAD:0:7} → ${REMOTE_HEAD:0:7}"
    git pull --quiet --ff-only origin main 2>/dev/null || git pull --quiet --ff-only origin master 2>/dev/null
    
    # Sync skill files to workspace
    rsync -a --delete \
        --exclude='.git' \
        --exclude='.github' \
        --exclude='README.md' \
        --exclude='LICENSE' \
        --exclude='.gitignore' \
        --exclude='.env*' \
        "${repo_path}/" "${SKILLS_DIR}/${skill_name}/"
    
    log "Updated skill: ${skill_name}"
}

# Sync core config repo (private)
sync_config() {
    local repo_path="${REPOS_DIR}/claw-config"
    local repo_url="git@github.com:Skitchy/claw-config.git"

    if [ ! -d "$repo_path" ]; then
        log "Cloning claw-config for the first time..."
        git clone --quiet "$repo_url" "$repo_path"
    fi

    cd "$repo_path"
    git fetch --quiet origin main 2>/dev/null || return

    local LOCAL_HEAD=$(git rev-parse HEAD)
    local REMOTE_HEAD=$(git rev-parse FETCH_HEAD)

    if [ "$LOCAL_HEAD" = "$REMOTE_HEAD" ]; then
        return
    fi

    log "Config repo updated: ${LOCAL_HEAD:0:7} → ${REMOTE_HEAD:0:7}"
    git pull --quiet --ff-only origin main

    # Sync workspace files (SOUL.md, AGENTS.md, USER.md, HEARTBEAT.md)
    for f in SOUL.md AGENTS.md USER.md HEARTBEAT.md; do
        if [ -f "${repo_path}/${f}" ]; then
            cp "${repo_path}/${f}" "${WORKSPACE}/${f}"
            log "Updated workspace file: ${f}"
        fi
    done

    # NOTE: openclaw.json is NOT auto-synced from repo.
    # It contains ${...} placeholders that must be resolved with .env values.
    # Config changes require manual review and application.
    if [ -f "${repo_path}/openclaw.json" ]; then
        log "NOTE: openclaw.json template updated in repo. Manual review required."
    fi
}

# ============================================================
# SKILL REPOS — Add new skills here
# Format: sync_skill "repo-name" "repo-url" "skill-folder-name"
# ============================================================

GITHUB_USER="Skitchy"

sync_config

sync_skill "RedClaw" \
    "https://github.com/${GITHUB_USER}/RedClaw.git" \
    "redclaw"

sync_skill "BlueClaw" \
    "https://github.com/${GITHUB_USER}/BlueClaw.git" \
    "blueclaw"

# Uncomment as you create these repos:
# sync_skill "HackerClaw" \
#     "https://github.com/${GITHUB_USER}/HackerClaw.git" \
#     "hackerclaw"

# sync_skill "XClaw" \
#     "https://github.com/${GITHUB_USER}/XClaw.git" \
#     "xclaw"

log "Deploy check complete."
