#!/usr/bin/bash

set -ouex pipefail

# set up ubi
UBI_URL="$(curl -sSL https://api.github.com/repos/houseabsolute/ubi/releases/latest |
  jq -r '.assets[] |select(.name |endswith("ubi-Linux-musl-x86_64.tar.gz")) |.browser_download_url')"
curl -sSL "$UBI_URL" |tar xz --no-same-owner -C /usr/bin ubi