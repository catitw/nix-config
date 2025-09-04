{
  lib,
  config,
  ...
}:
let
  sddm-enable = config.sys-opts.de.kde.enable || config.sys-opts.de.hyprland.enable;
in
{
  # TODO: add option for configuring display server: `wayland` or `x11`,
  # current config is assume we prefer `wayland`.

  options.sys-opts.de.kde = {
    enable = lib.mkEnableOption "the kde plasma";
    default = false;
  };

  options.sys-opts.de.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    default = false;
  };

  # enable sddm if one of them enabled
  config = lib.mkIf sddm-enable {
    # https://wiki.nixos.org/wiki/KDE
    services.xserver.enable = true; # optional

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      settings.General.DisplayServer = "wayland";
    };
  };
}
