{ pkgs, ... }:
{
  # for security reasons, do not load neovim's user config
  # since EDITOR may be used to edit some critical files
  environment.variables.EDITOR = "nvim --clean";

  environment.systemPackages = with pkgs; [
    # core tools
    tealdeer # a very fast version of tldr
    fastfetch
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    just # justfile
    nushell # nushell
    git # used by nix flakes
    git-lfs # used by huggingface models

    # nix utility
    nix-output-monitor
    nixfmt-rfc-style

    # archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # Text Processing
    # Docs: https://github.com/learnbyexample/Command-line-text-processing
    gnugrep # GNU grep, provides `grep`/`egrep`/`fgrep`
    ripgrep
    gnused # GNU sed, very powerful(mainly for replacing text in files)
    gawk # GNU awk, a pattern scanning and processing language
    jq # A lightweight and flexible command-line JSON processor

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    wget
    curl
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # security
    libargon2
    openssl

    # dev
    gcc
    gnumake
    cmake
    ninja
    meson
    pkg-config
    python3Full

    # misc
    file
    findutils
    which
    tree
    gnutar
    rsync
  ];

  # https://nixos.wiki/wiki/Visual_Studio_Code?__cf_chl_rt_tk=VIyf4K_Kj9e8WFYIkWy6V0v1dqcxsgdZRK.eik.JvdA-1755780341-1.0.1.1-byl2HohTQl76gXxJh87JKOt04ISDII49yLYCGMQxXkc#nix-ld
  programs.nix-ld.enable = true;
}
