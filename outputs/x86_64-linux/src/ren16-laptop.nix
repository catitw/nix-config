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
        opts.nvidia = {
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
        opts.defaultShell = "fish";

        opts.terminal.foot.enable = true;
        opts.terminal.alacritty.enable = false;
        opts.terminal.wezterm.enable = false;
      }
    ]
    ++ map mylib.relativeToRoot [
      "home/nixos/core"
      "home/nixos/tui"
      "home/nixos/gui"
    ];
  };

  # modules-hyprland = {
  #   nixos-modules = [
  #   ]
  #   ++ modules-base.nixos-modules;

  #   home-modules = [
  #     { modules.desktop.hyprland.enable = true; }
  #   ]
  #   ++ modules-base.home-modules;
  # };
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
