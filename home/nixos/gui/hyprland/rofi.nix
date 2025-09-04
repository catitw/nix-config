{ lib, osConfig, ... }:
let
  cfg = osConfig.sys-opts.de.hyprland;
in
{

  config = lib.mkIf cfg.enable {
    # https://mynixos.com/options/programs.rofi
    programs.rofi = {
      enable = true;
    };
  };
}
