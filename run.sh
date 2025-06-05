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

