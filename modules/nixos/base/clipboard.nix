{ pkgs, ... }:
{
  # see neovim ":help clipboard"
  environment.systemPackages = with pkgs; [
    wl-clipboard
    xclip
  ];
}
