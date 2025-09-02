{ pkgs, config, ... }:
let
  localBin = "${config.home.homeDirectory}/.local/bin";
  goBin = "${config.home.homeDirectory}/go/bin";
  rustBin = "${config.home.homeDirectory}/.cargo/bin";
  npmBin = "${config.home.homeDirectory}/.npm/bin";
in
{

  home.packages = with pkgs; [
    proxychains-ng
  ];

  home.file.".config/proxychains-ng/proxychains.conf" = {
    source = ./proxychains.conf;
  };

  programs.bash = {
    bashrcExtra = ''
      export PROXYCHAINS_CONF_FILE="$HOME/.config/proxychains-ng/proxychains.conf"
    '';
  };
}
