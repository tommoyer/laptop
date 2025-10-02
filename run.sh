#!/bin/bash

die() {
    (($#)) && printf >&2 '%s\n' "$@"
    usage
    exit 1
}

usage() {
  printf >&2 "$0\n"
}

export PATH=${PATH}:${HOME}/.local/bin

pkgs=""

if ! which pipx &> /dev/null
then
  pkgs+=" python-pipx "
  echo "Selecting pipx to be installed"
else
  echo "pipx already installed"
fi

if [[ $pkgs != "" ]]
then
  sudo pacman -Sy
  sudo pacman -S --noconfirm $pkgs
else
  echo "All packages installed"
fi

if ! pipx list | grep "package ansible" &> /dev/null
then
  pipx install --include-deps ansible
else
  echo "Ansible already installed"
fi

# Install any other things from requirements.txt
ansible-galaxy install -r requirements.yml

~/.local/bin/ansible-playbook playbook.yml -i inventory --ask-become-pass --ask-vault-pass -e "ansible_connection=local"

echo "Logging into Bitwarden"
export BW_SESSION="$(bw unlock --raw)"

# --- Settings ---
REPO_URL="${REPO_URL:-https://github.com/tommoyer/dotfiles.git}"

# --- Initialize or update from your repo and apply ---
CHEZ_SRC_DIR="${HOME}/.local/share/chezmoi"

if [ -d "${CHEZ_SRC_DIR}/.git" ]; then
  # Already initialized: ensure remote matches, then update+apply
  current_remote="$(git -C "${CHEZ_SRC_DIR}" remote get-url origin || true)"
  if [ "${current_remote}" != "${REPO_URL}" ]; then
    echo "Existing chezmoi source remote is '${current_remote}', switching to '${REPO_URL}'..."
    rm -rf "${CHEZ_SRC_DIR}"
    chezmoi init --apply "${REPO_URL}"
  else
    echo "Updating from '${REPO_URL}'..."
    chezmoi update --apply
  fi
else
  echo "Initializing chezmoi from '${REPO_URL}'..."
  chezmoi init --apply "${REPO_URL}"
fi

echo "Dotfiles applied successfully."
