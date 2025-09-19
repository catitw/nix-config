{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    rust-analyzer-nightly
    # rustup # note: install this will lead `RustRover` can not find rust-src
  ];
}
