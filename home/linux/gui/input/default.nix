{ pkgs, ... }:
{
  # https://nixos.wiki/wiki/Fcitx5
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    # NOTE: choose other `KDE Virtual Keyboard` setting or relogin if not showing
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      # not `kdePackages.fcitx5-configtool`, cause we enable `services.desktopManager.plasma6.enableQt5Integration` option
      # fcitx5-configtool
      kdePackages.fcitx5-configtool
      fcitx5-chinese-addons
      fcitx5-gtk # gtk im module
    ];
  };

  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
  };
}
