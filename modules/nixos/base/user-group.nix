{
  myvars,
  config,
  ...
}:
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
    extraGroups = [
      myvars.username
      "users"
      "networkmanager"
      "wheel"
      "podman"
      "wireshark"
    ];
  };
}
