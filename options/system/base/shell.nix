{
  lib,
  ...
}:
{
  options.sys-opts.defaultShell = lib.mkOption {
    type = lib.types.enum [
      "bash"
      "nushell"
      "fish"
    ];
    default = "fish";
    description = ''
      Select the preferred interactive login shell for this user ("nushell" or "fish").
    '';
  };
}
