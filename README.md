# Laptop Ansible Playbooks

Given my indecisive nature about the distro I use for my laptop/desktop computers, this repository has branches for each distro. To see available distros run:

```
git branch -a
```

To select a distro you can run:

```
git switch <branch-name>
```

If you want to add a new distro you can fork from one of the other distros:

```
git switch -c <new-branch-name> <existing-branch-name>
```

The structure of each branch is similar:

    .
    ├── files/              # Any static files needed for this playbook
    │   ├── common-u2f      # PAM configuration for YubiKey (as an example)
    │   └── ...
    ├── templates/          # Any templates needed for this playbook
    │   ├── finish-setup.j2 # Shell script to do any post-install setup (usually interactive things)
    │   └── ...
    ├── vars/               # Variable files (usually package lists and some secrets)
    │   ├── packages.yml    # List of packages to install
    │   └── ...
    ├── ansible.cfg         # Ansible configuration overrides
    ├── inventory           # "Inventory" for running playbook on the local machine
    ├── requirements.txt    # Ansible collections/roles required for this playbook
    ├── run.sh              # Shell script that takes care of running the playbook after installing dependencies
    └── playbook.yml        # The tasks to install and configure the machine

