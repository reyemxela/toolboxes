#!/usr/bin/env bash

set -ouex pipefail

copr_install_isolated() {
  local copr_name="$1"
  shift
  local packages=("$@")

  repo_id="copr:copr.fedorainfracloud.org:${copr_name//\//:}"

  echo "Installing ${packages[*]} from COPR $copr_name (isolated)"

  dnf5 -y copr enable "$copr_name"
  dnf5 -y copr disable "$copr_name"
  dnf5 -y install --enablerepo="$repo_id" "${packages[@]}"
}

third_party_install_isolated() {
  local repo_url="$1"
  local repo_id="$2"
  shift 2
  local packages=("$@")

  echo "Installing ${packages[*]} from $repo_id (isolated)"

  dnf config-manager addrepo --overwrite --from-repofile="$repo_url"
  dnf config-manager setopt "$repo_id".enabled=0
  dnf -y install --enablerepo="$repo_id" "${packages[@]}"
}


# basic packages
base=(
  "bat"
  "bind-utils"
  "btop"
  "dua-cli"
  "entr"
  "gh"
  "jq"
  "netcat"
  "nmap"
  "nvtop"
  "picocom"
  "python3-ipython"
  "socat"
  "strace"
  "tmux"
  "vim"
  "zsh"
)

dnf -y upgrade
dnf -y install ${base[@]}


# install UBI+packages
/scripts/install-ubi.sh
ubi -i /usr/bin -p eza-community/eza
ubi -i /usr/bin -p michel-kraemer/zsh-patina


# eza completions
TMPDIR="$(mktemp -d)"
ubi -i "$TMPDIR" -p eza-community/eza -r 'completions-.*.tar.gz' --extract-all
mv "$TMPDIR"/completions-*/eza /usr/share/bash-completion/completions/
mv "$TMPDIR"/completions-*/_eza /usr/share/zsh/site-functions/