{
  lib,
  osConfig,
  ...
}:
let
  enabled = osConfig.sys-opts.defaultShell == "nushell";
in
{
  # config = lib.mkIf enabled {
  #   programs.nushell = {
  #     enable = true;
  #   };
  # };
}
