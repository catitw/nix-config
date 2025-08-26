#!/usr/bin/env bash

set -ex

# https://nixos-and-flakes.thiscute.world/zh/nix-store/add-binary-cache-servers#accelerate-package-downloads-via-a-proxy-server

sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
sudo cat <<EOF >/run/systemd/system/nix-daemon.service.d/override.conf
[Service]
Environment="https_proxy=http://10.0.1.124:7897"
EOF
sudo systemctl daemon-reload
sudo systemctl restart nix-daemon
