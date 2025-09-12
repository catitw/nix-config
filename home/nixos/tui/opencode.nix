{
  pkgs,
  config,
  osConfig,
  ...
}:
{
  home.file.".local/share/opencode/auth.json".source =
    config.lib.file.mkOutOfStoreSymlink
      osConfig.sops.templates."opencode-auth.json".path;

  home.file.".config/opencode/config.jsonc".source =
    config.lib.file.mkOutOfStoreSymlink
      osConfig.sops.templates."opencode-config.jsonc".path;

  home.packages = with pkgs; [
    opencode
  ];

  # programs.opencode = {
  #   enable = true;
  #   # [options](https://mynixos.com/home-manager/option/programs.opencode.settings)
  #   settings = {
  #     provider = {
  #       zhipuai = {
  #         # https://docs.z.ai/scenario-example/develop-tools/opencode#using-opencode-with-the-glm-coding-plan
  #         api = "https://open.bigmodel.cn/api/paas/v4";
  #       };
  #     };
  #   };
  # };
}
