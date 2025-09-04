{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.sys-opts.de.kde;
in
{
  config = lib.mkIf cfg.enable {

    # https://wiki.nixos.org/wiki/KDE
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      konsole
      elisa
    ];
  };
}
