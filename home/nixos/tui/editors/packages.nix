{ pkgs
, pkgs-unstable
, ...
}:
{
  home.packages = with pkgs; [
    fzf
    fd
    ripgrep
    tree-sitter
  ];
}
