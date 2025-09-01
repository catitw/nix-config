{ pkgs, lib, ... }:
{
  networking.networkmanager.enable = true;
  networking.useDHCP = lib.mkForce true;
  networking.dhcpcd.enable = true;

  # Configure DNS servers manually
  # https://archlinuxstudio.github.io/ArchLinuxTutorial/#/rookie/DE&App?id=_8-%e8%ae%be%e7%bd%ae-dns
  networking.nameservers = [
    "8.8.8.8"
    "2001:4860:4860::8888"
    "8.8.4.4"
    "2001:4860:4860::8844"
  ];
}
