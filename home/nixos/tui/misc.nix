{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    fzf
    fd
    ripgrep
  ];

  programs = {
    # Git terminal UI (written in go).
    lazygit.enable = true;
    # Yet another Git TUI (written in rust).
    # gitui.enable = true;
  };
}
