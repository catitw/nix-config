{
  pkgs,
  myvars,
  config,
  ...
}:

let
  cfg = config.sys-opts;

  shellPkg =
    if cfg.defaultShell == "fish" then
      pkgs.fish
    else if cfg.defaultShell == "nu" then
      pkgs.nushell
    else if cfg.defaultShell == "zsh" then
      pkgs.zsh
    else
      pkgs.bashInteractive; # fallback: bash
in
{
  # Don't allow mutation of users outside the config.
  users.mutableUsers = false;

  users.groups = {
    "${myvars.username}" = { };
    podman = { };
    wireshark = { };
  };

  users.users."${myvars.username}" = {
    hashedPasswordFile = config.sops.secrets.password_hash.path;
    home = "/home/${myvars.username}";
    isNormalUser = true;
    description = myvars.userfullname;
    extraGroups = [
      myvars.username
      "users"
      "networkmanager"
      "wheel"
      "podman"
      "wireshark"
    ];
    shell = shellPkg;
  };
}
