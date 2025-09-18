{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  myvars,
  mylib,
  system,
  genSpecialArgs,
  ...
}@args:
let
  name = "ren16-laptop";

  modules-base = {
    nixos-modules = [
      {
        sys-opts = {
          defaultShell = "fish";

          nvidia = {
            enable = true;
            open = true;
            powerManagement = {
              enable = false;
              finegrained = false;
            };
            prime = {
              mode = "offload";
              enableOffloadCmd = true;
              integratedType = "intel";
              intelBusId = "PCI:0:2:0";
              nvidiaBusId = "PCI:1:0:0";
            };
          };

          de = {
            kde.enable = true;
            hyprland.enable = true;
          };
        };
      }
      {
        # https://wiki.nixos.org/wiki/KDE#Bluetooth_configuration_not_available
        hardware.bluetooth.enable = true;

        nixpkgs.config.allowUnfree = lib.mkForce true;
      }
    ]
    ++ map mylib.relativeToRoot [
      "modules/base"
      "modules/nixos/base"
      "modules/nixos/desktop"
      "hosts/${name}"
    ];

    home-modules = [
      {
        home-opts = {
          terminal = {
            foot.enable = true;
            alacritty.enable = false;
            wezterm.enable = false;
          };
        };
      }
    ]
    ++ map mylib.relativeToRoot [
      "home/base"
      "home/nixos"
    ];
  };

in
{
  debugAttrs = {
    inherit
      modules-base
      ;

    tui = import (mylib.relativeToRoot "home/nixos/tui") args;
  };

  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (modules-base // args);
    # "${name}-hyprland" = mylib.nixosSystem (modules-hyprland // args);
  };
}
