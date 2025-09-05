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


    # lua
    stylua # lua formatter
    selene # lua linter
    lua-language-server # lua lsp
  ];
}
