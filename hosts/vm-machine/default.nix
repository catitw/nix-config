{ myvars, lib, ... }:
let
  hostName = "vm-machine";
in
{
  imports = [
    ./hardware-configuration.nix
    # ./nvidia.nix
  ];

  networking = {
    inherit hostName;

    useDHCP = lib.mkDefault true;
  };
}
