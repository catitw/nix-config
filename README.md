## How to install new OS

1. setup disk
2. copy to file `hardware-configuration.nix` to folder `hosts/${name}`
3. run command `nixos-install --flake .#${name}`
   > for example:
   > ```shell
   > nixos-install --flake .#vm-machine --show-trace --verbose --option substituters "https://mirrors.ustc.edu.cn/nix-channels/store  https://cache.nixos.org/"
   > ```