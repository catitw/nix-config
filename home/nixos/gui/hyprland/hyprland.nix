{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  cfg = osConfig.sys-opts.de.hyprland;
in
{
  config = lib.mkIf cfg.enable {

    xdg.configFile =
      let
        mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      in
      {
        "hypr/configs".source = mkSymlink ./conf;
      };

    wayland.windowManager.hyprland = {
      enable = true;
      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      # [Using the Home-Manager module with NixOS](https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/#using-the-home-manager-module-with-nixos)
      package = null;
      portalPackage = null;
      # package = pkgs.hyprland;
      # portalPackage = pkgs.xdg-desktop-portal-hyprland;

      settings = {
        source =
          let
            configPath = "${config.home.homeDirectory}/.config/hypr/configs";
          in
          [
            "${configPath}/exec.conf"
            # "${configPath}/fcitx5.conf"
            "${configPath}/keybindings.conf"
            # "${configPath}/settings.conf"
            # "${configPath}/windowrules.conf"
          ];
        env = [

        ];
      };

      xwayland.enable = true;

      # gammastep/wallpaper-switcher need this to be enabled.
      systemd = {
        enable = true;
        variables = [ "--all" ];
      };

    };
  };
}
