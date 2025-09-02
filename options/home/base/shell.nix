{
  lib,
  ...
}:
{
  options.opts.defaultShell = lib.mkOption {
    type = lib.types.enum [
      "nushell"
      "fish"
    ];
    default = "nushell";
    description = ''
      Select the preferred interactive login shell for this user ("nushell" or "fish").
    '';
  };
}
