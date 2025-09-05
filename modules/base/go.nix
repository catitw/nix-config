{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    stylua # formatter
    selene # linter
    lua-language-server # lsp
  ];
}
