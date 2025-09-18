{
  pkgs,
  ...
}:
{

  # [Use VS Code extensions without additional configuration](https://nixos.wiki/wiki/Visual_Studio_Code#Use_VS_Code_extensions_without_additional_configuration)
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vadimcn.vscode-lldb
    ];
  };
  catppuccin.vscode.profiles.default.enable = false;
}
