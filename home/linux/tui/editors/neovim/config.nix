{ my-lazyvim, config, ... }:
{
  home.file.".config/nvim" = {
    # source = config.lib.file.mkOutOfStoreSymlink /tmp/LazyVim;
    source = my-lazyvim;
    recursive = true;
  };
}
