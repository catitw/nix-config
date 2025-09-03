{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    feishu
  ];

  # [Use VS Code extensions without additional configuration](https://nixos.wiki/wiki/Visual_Studio_Code#Use_VS_Code_extensions_without_additional_configuration)
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  catppuccin.vscode.enable = false;
}
