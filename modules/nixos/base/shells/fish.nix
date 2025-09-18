{
  lib,
  pkgs,
  config,
  ...
}:
let
  enabled = config.sys-opts.defaultShell == "fish";
in
{

  config = lib.mkIf enabled {

    # environment.systemPackages = with pkgs; [
    #   fishPlugins.done
    #   fishPlugins.fzf-fish
    #   fishPlugins.forgit
    #   fishPlugins.hydro
    #   fzf
    #   fishPlugins.grc
    #   grc
    # ];

    programs.fish = {
      enable = true;
    };
  };
}
