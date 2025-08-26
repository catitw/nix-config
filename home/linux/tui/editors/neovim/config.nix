{ my-lazyvim, config, ... }:
{
  home.file.".config/nvim" = {
    # source = config.lib.file.mkOutOfStoreSymlink /tmp/LazyVim;
    source = my-lazyvim;
    recursive = true;
  };

  # Disable catppuccin to avoid conflict with my non-nix config.
  catppuccin.nvim.enable = false;
}
