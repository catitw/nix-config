{
  lib,
  pkgs,
  config,
  ...
}:
let
  enabled = config.home-opts.defaultShell == "fish";
in
{
  config = lib.mkIf enabled {

    home.packages = with pkgs; [
      fish
      grc
    ];
    programs.fish = {
      enable = true;
      # interactiveShellInit = ''
      #   set fish_greeting # Disable greeting
      # '';
      plugins = [
        # Enable a plugin (here grc for colorized command output) from nixpkgs
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
      ];
    };
    catppuccin.fish.enable = true;

    # https://nixos.wiki/wiki/Fish#Setting_fish_as_your_shell
    programs.bash.initExtra = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';

  };
}
