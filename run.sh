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
  pkgs+=" pipx "
  echo "Selecting pipx to be installed"
else
  echo "pipx already installed"
fi

if rpm -q python3-libdnf5 &>/dev/null; then
  echo "python3-libdnf5 is already installed"
else
  pkgs+=" python3-libdnf5 "
  echo "Selecting python3-libdnf5 to be installed"
fi

if [[ $pkgs != "" ]]
then
  sudo dnf install -y $pkgs
else
  echo "All packages installed"
fi

if ! pipx list | grep "package ansible" &> /dev/null
then
  pipx install --include-deps ansible
else
  echo "Ansible already installed"
fi

if ! ~/.local/bin/ansible-galaxy collection list | grep community.general &> /dev/null
then
  ~/.local/bin/ansible-galaxy collection install community.general
else
  echo "Skipping installation of community.general"
fi

# Install any other things from requirements.txt
ansible-galaxy install -r requirements.yml

~/.local/bin/ansible-playbook playbook.yml -i inventory --ask-become-pass --ask-vault-pass -e "ansible_connection=local"

