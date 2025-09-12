{
  mylib,
  myvars,
  my-secrets,
  config,
  ...
}:
{
  sops = {
    defaultSopsFile = mylib.relativeToRoot "secrets/.sops.yaml";
    # Don't mix sshKeyPaths and keyFile
    age.sshKeyPaths = [ ];
    age.keyFile = "/persist/sops/age/keys.txt";

    secrets = {
      "password_hash" = {
        sopsFile = "${my-secrets}/password-hash.yaml";
        owner = "root";
        group = "root";
        mode = "0400";
        neededForUsers = true;
      };
      "github_deploy_key_ed25519" = {
        sopsFile = "${my-secrets}/github-deploy-key.yaml";
        key = "github_deploy_key_ed25519";
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "zhipu_ai_key" = {
        sopsFile = "${my-secrets}/zhipu-ai.yaml";
        key = "api_key";
        owner = "root";
        group = "root";
        mode = "0400";
      };
      "mcp_context7_key" = {
        sopsFile = "${my-secrets}/mcp.yaml";
        format = "yaml";
        # https://discourse.nixos.org/t/sops-nix-secrets-yaml-is-not-valid-and-key-cannot-be-found/68071/5
        key = "context7/api_key";
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };

    templates = {
      "opencode-auth.json" = {
        content = ''
          {
            "zhipuai": {
              "type": "api",
              "key": "${config.sops.placeholder.zhipu_ai_key}"
            }
          }
        '';
        owner = myvars.username;
        group = myvars.username;
        mode = "0600";
      };
      "opencode-config.jsonc" = {
        content = ''
          {
            "$schema": "https://opencode.ai/config.json",
            "provider": {
              "zhipuai": {
                "api": "https://open.bigmodel.cn/api/paas/v4"
              }
            },
            "mcp": {
                // https://github.com/upstash/context7?tab=readme-ov-file#opencode-remote-server-connection
                "context7": {
                  "type": "remote",
                  "url": "https://mcp.context7.com/mcp",
                  "headers": {
                    "CONTEXT7_API_KEY": "${config.sops.placeholder.mcp_context7_key}"
                  },
                  "enabled": true
                }
            },
          }
        '';
        owner = myvars.username;
        group = myvars.username;
        mode = "0600";
      };
    };
  };
}
