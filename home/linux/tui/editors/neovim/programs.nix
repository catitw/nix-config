{
  pkgs,
  pkgs-unstable,
  config,
  ...
}:
{

  home.packages = with pkgs; [
    lazygit
    fzf
    fd
    ripgrep
    nodejs_24
    tree-sitter
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim = {
    enable = false;
    package = pkgs-unstable.neovim-unwrapped;

    vimAlias = true;
    vimdiffAlias = true;
  };
}
