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
    };
  };
}
