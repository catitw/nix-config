{ mylib, my-secrets, ... }:
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
    };
  };
}
