{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    uv # python project package manager
  ];
}
