{
  lib,
  config,
  pkgs,
  ...
}:
let
  enabled = config.sys-opts.defaultShell == "nushell";
in
{
  environment.systemPackages = with pkgs; [
    nushell
  ];
}
