#!/usr/bin/env bash

set -exuo pipefail

# https://nixos-and-flakes.thiscute.world/zh/nix-store/add-binary-cache-servers#accelerate-package-downloads-via-a-proxy-server

if [ "$EUID" -ne 0 ]; then
  exec sudo -p "[sudo] enter password to continue: " -- "$0" "$@"
fi

mkdir -p /run/systemd/system/nix-daemon.service.d/
cat <<EOF >/run/systemd/system/nix-daemon.service.d/override.conf
[Service]
Environment="https_proxy=http://10.0.1.124:7897"
EOF
systemctl daemon-reload
systemctl restart nix-daemon
