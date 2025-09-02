{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.opts.terminal.wezterm;
in
{
  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      wezterm
    ];

  };
}
