{
  lib,
  config,
  ...
}:
let
  enabled = config.home-opts.defaultShell == "nushell";
in
{
  config = lib.mkIf enabled {
    programs.nushell = {
      enable = true;
    };
  };
}
