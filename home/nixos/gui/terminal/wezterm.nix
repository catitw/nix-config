{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.home-opts.terminal.wezterm;
in
{
  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      wezterm
    ];

  };
}
