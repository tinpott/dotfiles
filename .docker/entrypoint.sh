#!/bin/bash

set -euo pipefail

REPO_URL="${REPO_URL:-git@github.com:tinpott/dotfiles.git}"
BRANCH="${BRANCH:-main}"
REPO_DIR=/work/dotfiles

if [ -d /root/.ssh-host ]; then
    mkdir -p /root/.ssh
    cp -rT /root/.ssh-host /root/.ssh
    chmod 700 /root/.ssh
    find /root/.ssh -type f -exec chmod 600 {} +
fi

mkdir -p /root/.ssh
touch /root/.ssh/known_hosts
if ! grep -q '^github.com ' /root/.ssh/known_hosts 2>/dev/null; then
    cat /etc/ssh-seed/known_hosts >> /root/.ssh/known_hosts
fi
chmod 600 /root/.ssh/known_hosts

if [ ! -d "${REPO_DIR}/.git" ]; then
    git clone "${REPO_URL}" "${REPO_DIR}"
fi

cd "${REPO_DIR}"
git fetch --all --prune
if git show-ref --verify --quiet "refs/heads/${BRANCH}"; then
    git checkout "${BRANCH}"
elif git ls-remote --exit-code --heads origin "${BRANCH}" >/dev/null 2>&1; then
    git checkout -t "origin/${BRANCH}"
else
    git checkout -b "${BRANCH}"
fi

exec "$@"
