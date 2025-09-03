{
  lib,
  ...
}:
{

  # NOTE: foot is designed only for Linux
  options.home-opts.terminal.foot = {
    enable = lib.mkEnableOption "the foot program and configuration";
    default = true;
  };
}
