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
  name = "vm-machine";

  modules-base = {
    nixos-modules = map mylib.relativeToRoot [
      "modules/base"
      "modules/nixos/base"
      "hosts/${name}"
    ];

    home-modules = map mylib.relativeToRoot [
      "home/nixos/core"
      "home/nixos/tui"
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
