{
  lib,
  config,
  ...
}:
let
  enabled = config.opts.defaultShell == "nushell";
in
{
  config = lib.mkIf enabled {
    programs.nushell = {
      enable = true;
    };
  };
}
