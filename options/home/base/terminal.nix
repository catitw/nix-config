{
  lib,
  ...
}:
{

  options.home-opts.terminal.alacritty = {
    enable = lib.mkEnableOption "the alacritty program and configuration";
    default = false;
  };

  options.home-opts.terminal.wezterm = {
    enable = lib.mkEnableOption "the wezterm program and configuration";
    default = false;
  };

}
