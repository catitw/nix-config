{
  lib,
  config,
  pkgs,
  ...
}:
let
  nushell-enabled = config.opts.defaultShell == "nushell";
in
{
  programs.zellij = {
    enable = true;
    package = pkgs.zellij;
  };
  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
  # Disable catppuccin to avoid conflict with my non-nix config.
  catppuccin.zellij.enable = false;

  # auto start zellij in nushell
  programs.nushell = lib.mkIf nushell-enabled {
    extraConfig = ''
      # auto start zellij
      # except when in emacs or zellij itself
      if (not ("ZELLIJ" in $env)) and (not ("INSIDE_EMACS" in $env)) {
        if "ZELLIJ_AUTO_ATTACH" in $env and $env.ZELLIJ_AUTO_ATTACH == "true" {
          ^zellij attach -c
        } else {
          ^zellij
        }

        # Auto exit the shell session when zellij exit
        $env.ZELLIJ_AUTO_EXIT = "false" # disable auto exit
        if "ZELLIJ_AUTO_EXIT" in $env and $env.ZELLIJ_AUTO_EXIT == "true" {
          exit
        }
      }
    '';
  };
}
