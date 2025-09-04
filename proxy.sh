#!/usr/bin/env bash

# https://nixos-and-flakes.thiscute.world/zh/nix-store/add-binary-cache-servers#accelerate-package-downloads-via-a-proxy-server

set -exuo pipefail

SCRIPT_NAME="$(basename "$0")"
DROPIN_DIR="/run/systemd/system/nix-daemon.service.d"
DROPIN_FILE="${DROPIN_DIR}/override.conf"
PROXY_URL="http://127.0.0.1:7897"

usage() {
  cat <<EOF
Usage:
  $SCRIPT_NAME            Apply a temporary all_proxy for nix-daemon (runtime only)
  $SCRIPT_NAME --undo     Remove the temporary all_proxy override
  $SCRIPT_NAME --help     Show this help message

Description:
  Creates a systemd drop-in at:
    ${DROPIN_FILE}
  containing:
    [Service]
    Environment="http_proxy=${PROXY_URL}"
    Environment="https_proxy=${PROXY_URL}"
    Environment="all_proxy=${PROXY_URL}"

  Because it is placed under /run (a tmpfs), the override disappears after a reboot.
  The service is restarted to make the new environment effective.

Options:
  --undo   Remove the drop-in file (if present) and restart nix-daemon.
  --help   Show this help and exit.

Exit codes:
  0 on success
  Non-zero on errors

Notes:
  - Requires root (sudo) except for --help.
EOF
}

# Parse arguments
UNDO=0
while [ $# -gt 0 ]; do
  case "$1" in
  --help | -h)
    usage
    exit 0
    ;;
  --undo)
    UNDO=1
    ;;
  *)
    echo "Error: Unknown option: $1" >&2
    usage >&2
    exit 1
    ;;
  esac
  shift
done

ensure_root() {
  if [ "${EUID}" -ne 0 ]; then
    # Preserve flags that were passed (currently only --undo)
    if [ $UNDO -eq 1 ]; then
      exec sudo -p "[sudo] enter password to continue: " -- "$0" --undo
    else
      exec sudo -p "[sudo] enter password to continue: " -- "$0"
    fi
  fi
}

if [ $UNDO -eq 1 ]; then
  ensure_root
  if [ -f "${DROPIN_FILE}" ]; then
    rm -f "${DROPIN_FILE}"
  fi
  systemctl daemon-reload
  systemctl restart nix-daemon
  exit 0
fi

# Apply override
ensure_root
mkdir -p "${DROPIN_DIR}"

cat >"${DROPIN_FILE}" <<EOF
[Service]
Environment="http_proxy=${PROXY_URL}"
Environment="https_proxy=${PROXY_URL}"
Environment="all_proxy=${PROXY_URL}"
EOF

systemctl daemon-reload
systemctl restart nix-daemon
