{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    jetbrains.rust-rover
    jetbrains.clion
    jetbrains.goland
  ];
}
