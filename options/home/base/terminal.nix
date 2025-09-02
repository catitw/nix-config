{
  lib,
  ...
}:
{

  options.opts.terminal.alacritty = {
    enable = lib.mkEnableOption "the alacritty program and configuration";
    default = false;
  };

  options.opts.terminal.wezterm = {
    enable = lib.mkEnableOption "the wezterm program and configuration";
    default = false;
  };

}
