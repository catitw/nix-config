{ lib, osConfig, ... }:
let
  cfg = osConfig.sys-opts.de.hyprland;
in
{

  config = lib.mkIf cfg.enable {
    # status bar
    programs.waybar = {
      enable = true;
      systemd.enable = false;
    };
    # Disable catppuccin to avoid conflict with my non-nix config.
    catppuccin.waybar.enable = false;
  };
}
