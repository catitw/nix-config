set shell := ["bash", "-c"]

# List all the just commands
default:
    @just --list

# Install new os.. 
# NOTE: update `hardware-configuration.nix` first.
[group('bootstrap')]
install:
  nixos-install --flake .#vm-machine --show-trace --verbose --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store  https://cache.nixos.org/"

# Update all the flake inputs
[group('nix')]
up:
  nix flake update --commit-lock-file

# Rebuild and switch to new configuration
[group('nix')]
switch:
  nixos-rebuild switch --sudo --flake .#$(hostname) |& nom

# Garbage collect all unused nix store entries
[group('nix')]
gc:
  # garbage collect all unused nix store entries(system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # garbage collect all unused nix store entries(for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d