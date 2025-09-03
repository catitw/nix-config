{
  lib,
  config,
  ...
}:
let
  cfg = config.home-opts.terminal.foot;
in
{
  config = lib.mkIf cfg.enable {

    # NOTE: foot is designed only for Linux
    programs.foot = {
      enable = true;

      # foot can also be run in a server mode. In this mode, one process hosts multiple windows.
      # All Wayland communication, VT parsing and rendering is done in the server process.
      # New windows are opened by running footclient, which remains running until the terminal window is closed.
      #
      # Advantages to run foot in server mode including reduced memory footprint and startup time.
      # The downside is a performance penalty. If one window is very busy with, for example, producing output,
      # then other windows will suffer. Also, should the server process crash, all windows will be gone.
      server.enable = true;

      # https://man.archlinux.org/man/foot.ini.5
      settings = {
        main = {
          term = "foot"; # or "xterm-256color" for maximum compatibility
          font = "Maple Mono NF CN:size=14";
          dpi-aware = "no"; # scale via window manager instead
          initial-window-size-chars = "160x40";

          # Spawn a nushell in login mode via `bash`
          # shell = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";
        };

        key-bindings = {
          scrollback-up-half-page = "Page_Up";
          scrollback-down-half-page = "Page_Down";
          font-increase = "Control+Shift+plus";
          font-decrease = "Control+Shift+minus";
          font-reset = "Control+Shift+0";
          quit = "Control+Shift+q";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };

  };
}
