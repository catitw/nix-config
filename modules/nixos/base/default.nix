{ mylib, ... }:
let
  baseModules = mylib.scanPaths ../../base;
  thisModules = mylib.scanPaths ./.;
in
{
  imports = baseModules ++ thisModules;
}

