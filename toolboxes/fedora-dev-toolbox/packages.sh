#!/usr/bin/env bash

set -ouex pipefail

. /scripts/fedora-packages.sh

third_party_install_isolated "https://packages.microsoft.com/yumrepos/vscode/config.repo" "vscode-yum" \
  "code"

packages=(
  @c-development
  cmake
  golang
  golang-misc
)

dnf -y install ${packages[@]}