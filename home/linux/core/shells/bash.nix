{
  lib,
  config,
  ...
}:
let

  homeDir = config.home.homeDirectory;
  extraPaths = [
    "${homeDir}/.local/bin"
    "${homeDir}/go/bin"
    "${homeDir}/.cargo/bin"
    "${homeDir}/.npm/bin"
  ];

  pathForBash = lib.concatStringsSep ":" extraPaths;
in
{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:${pathForBash}"
    '';
  };
}
