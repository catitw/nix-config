{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    llvmPackages_21.clang
    llvmPackages_21.clang-tools # clangd / clang-format
    llvmPackages_21.lld
    llvmPackages_21.lldb
  ];
}
