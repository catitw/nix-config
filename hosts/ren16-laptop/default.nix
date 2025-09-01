{ myvars, lib, ... }:
let
  hostName = "ren16-laptop";
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
