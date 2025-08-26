{ fenix, ... }@args: {
  nixpkgs.overlays = [ fenix.overlays.default ] ++ (import ../../overlays args);
}
