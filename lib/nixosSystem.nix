{
  inputs,
  lib,
  system,
  genSpecialArgs,
  nixos-modules,
  home-modules ? [ ],
  preference-modules ? [ ], # preference options settings
  specialArgs ? (genSpecialArgs system),
  myvars,
  mylib,
  ...
}:
let
  inherit (inputs) nixpkgs home-manager nixos-generators;
  options-modules = map mylib.relativeToRoot [
    "options"
  ];
in
# [Simple Introduction to nixpkgs.lib.nixosSystem Function](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-configuration-explained#simple-introduction-to-nixpkgs-lib-nixos-system)
nixpkgs.lib.nixosSystem {
  inherit system specialArgs;

  modules =
    options-modules
    ++ preference-modules
    ++ nixos-modules
    ++ [
      # nixos-generators.nixosModules.all-formats
    ]
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [

      # [Getting Started with Home Manager](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager)
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "home-manager.backup";

        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users."${myvars.username}".imports =
          options-modules ++ preference-modules ++ home-modules;
      }
    ]);
}
