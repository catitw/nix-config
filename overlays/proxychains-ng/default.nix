args:
(self: super: {

  proxychains-ng = super.proxychains-ng.overrideAttrs (old: {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/pr/proxychains-ng/package.nixs
    src = super.fetchFromGitHub {
      owner = "rofl0r";
      repo = "proxychains-ng";
      rev = "v${old.version}";
      sha256 = "sha256-cHRWPQm6aXsror0z+S2Ddm7w14c1OvEruDublWsvnXs=";
    };
    version = "${old.version}-quiet";

    patches = (old.patches or [ ]) ++ [
      ./default-quiet-mode.patch
    ];

  });
})
