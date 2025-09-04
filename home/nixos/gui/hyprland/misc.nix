{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = osConfig.sys-opts.de.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    # screen locker
    programs.swaylock.enable = true;

    # Logout Menu
    programs.wlogout.enable = true;
    catppuccin.wlogout.enable = false;

    # Hyprland idle daemon
    services.hypridle.enable = true;

    # notification daemon, the same as dunst
    services.mako.enable = true;
    catppuccin.mako.enable = false;

    home.packages = with pkgs; [
      swaybg # the wallpaper
      wl-clipboard # copying and pasting
      hyprpicker # color picker
      brightnessctl
      hyprshot # screen shot
      wf-recorder # screen recording
      # audio
      alsa-utils # provides amixer/alsamixer/...
      networkmanagerapplet # provide GUI app: nm-connection-editor
    ];
  };
}
