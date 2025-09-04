{ ... }:
{
  # status bar
  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
  # Disable catppuccin to avoid conflict with my non-nix config.
  catppuccin.waybar.enable = false;
}
