{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:
{
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  # GitHub CLI tool
  # https://cli.github.com/manual/
  programs.gh = {
    enable = true;
    # settings = {
    #   git_protocol = "ssh";
    #   prompt = "enabled";
    #   aliases = {
    #     co = "pr checkout";
    #     pv = "pr view";
    #   };
    # };
    # hosts = {
    #   "github.com" = {
    #     "users" = {
    #       "catitw" = null;
    #     };
    #     "user" = "catitw";
    #   };
    # };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = myvars.userfullname;
    userEmail = myvars.useremail;

    includes = [
      # {
      #   # use different email & name for work
      #   path = "~/work/.gitconfig";
      #   condition = "gitdir:~/work/";
      # }
    ];

    extraConfig = {
      init.defaultBranch = "main";
      trim.bases = "develop,master,main"; # for git-trim
      push.autoSetupRemote = true;
      pull.rebase = true;
      log.date = "iso"; # use iso format for date

      # replace https with ssh
      url = {
        # "ssh://git@gitlab.com/" = {
        #   insteadOf = "https://gitlab.com/";
        # };
        # "ssh://git@bitbucket.com/" = {
        #   insteadOf = "https://bitbucket.com/";
        # };
      };
    };

    # NOTE: generate ssh key:
    # `ssh-keygen -t ed25519 -C "your_email@example.com"`
    # > https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
    #
    # signing = {
    #   key = "xxx";
    #   signByDefault = true;
    # };

    # A syntax-highlighting pager for git, diff, grep, and blame output
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
        # features => named groups of settings, used to keep related settings organized
        # features = "";
      };
    };
  };
}
