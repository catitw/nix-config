{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  my-nvim-conf,
  ...
}:
{

  imports = [
    my-nvim-conf.homeModules.default
  ];

  nvim.enable = true;
  # Disable catppuccin to avoid conflict with my non-nix config.
  catppuccin.nvim.enable = false;
  home.sessionVariables = {
    EDITOR = "nvim";
  };
}
