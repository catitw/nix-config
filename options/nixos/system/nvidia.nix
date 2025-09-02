{
  lib,
  config,
  ...
}:
let
  cfg = config.opts.nvidia;
in
{
  # https://nixos.wiki/wiki/Nvidia
  # https://discourse.nixos.org/t/there-are-3-nvidia-wiki-pages-for-nixos/64066
  options.opts.nvidia = {
    enable = lib.mkEnableOption "Enable NVIDIA driver and optional PRIME configuration.";

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = lib.mkOption {
      type = lib.types.package;
      default = config.boot.kernelPackages.nvidiaPackages.stable;
      defaultText = lib.literalExpression "config.boot.kernelPackages.nvidiaPackages.stable";
      description = "NVIDIA driver package to use.";
    };

    open = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use the NVidia open source kernel module (not to be confused with the
        independent third-party "nouveau" open source driver).
        Support is limited to the Turing and later architectures. Full list of 
        supported GPUs is at: 
        https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
        Only available from driver 515.43.04+
      '';
    };

    powerManagement = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Nvidia power management. Experimental, and can cause sleep/suspend to fail.
          Enable this if you have graphical corruption issues or application crashes after waking
          up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
          of just the bare essentials.
        '';
      };

      finegrained = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Fine-grained power management. Turns off GPU when not in use.
          Experimental and only works on modern Nvidia GPUs (Turing or newer).
        '';
      };
    };

    prime = {
      mode = lib.mkOption {
        type = lib.types.enum [
          "none"
          "offload"
          "sync"
          "reverseSync"
        ];
        default = "none";
        description = ''
          PRIME mode:
            none         - Do not enable PRIME features (stand‑alone NVIDIA GPU).
            offload      - Use the integrated GPU by default, offload specific apps to NVIDIA.
            sync         - NVIDIA renders, synchronized to integrated display outputs.
            reverseSync  - Integrated GPU drives the display, NVIDIA renders and is reverse-synced.
        '';
      };

      integratedType = lib.mkOption {
        type = lib.types.enum [
          "intel"
          "amd"
        ];
        default = "intel";
        description = "Type of the integrated GPU. Determines which driver entry (modesetting or amdgpu) is added for offload mode.";
      };

      enableOffloadCmd = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Only relevant in offload mode: whether to enable the offload-run wrapper command.";
      };

      allowExternalGpu = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Only relevant in reverseSync mode: allow usage of an external GPU.";
      };

      intelBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Bus ID of the Intel iGPU (e.g. PCI:0:2:0). Required when integratedType=intel and PRIME mode != none.";
      };

      amdgpuBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Bus ID of the AMD iGPU (e.g. PCI:54:0:0). Required when integratedType=amd and PRIME mode != none.";
      };

      nvidiaBusId = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Bus ID of the NVIDIA GPU (e.g. PCI:1:0:0). Required when PRIME mode is offload/sync/reverseSync.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    let
      primeCfg = cfg.prime;
      needPrime = primeCfg.mode != "none";

      integratedBusId =
        if primeCfg.integratedType == "intel" then primeCfg.intelBusId else primeCfg.amdgpuBusId;

      # Mode-specific enabling attributes
      primeModeAttrs =
        if !needPrime then
          { }
        else if primeCfg.mode == "offload" then
          {
            prime.offload.enable = true;
            prime.offload.enableOffloadCmd = primeCfg.enableOffloadCmd;
          }
        else if primeCfg.mode == "sync" then
          {
            prime.sync.enable = true;
          }
        else
          {
            # reverseSync
            prime.reverseSync.enable = true;
            prime.reverseSync.allowExternalGpu = primeCfg.allowExternalGpu;
          };

      # Bus IDs (added only when PRIME is active)
      primeBusAttrs =
        if !needPrime then
          { }
        else
          (
            if primeCfg.integratedType == "intel" then
              {
                prime.intelBusId = integratedBusId;
              }
            else
              {
                prime.amdgpuBusId = integratedBusId;
              }
          )
          // {
            prime.nvidiaBusId = primeCfg.nvidiaBusId;
          };

      videoDrivers =
        if !needPrime then
          [ "nvidia" ]
        else if primeCfg.mode == "offload" then
          [
            (if primeCfg.integratedType == "intel" then "modesetting" else "amdgpu")
            "nvidia"
          ]
        else
          [ "nvidia" ];
    in
    {
      assertions = [
        {
          assertion = !(needPrime && primeCfg.nvidiaBusId == null);
          message = "opts.nvidia.prime: PRIME mode selected but nvidiaBusId is not set.";
        }
        {
          assertion = !(needPrime && primeCfg.integratedType == "intel" && primeCfg.intelBusId == null);
          message = "opts.nvidia.prime: integratedType=intel with PRIME requires intelBusId.";
        }
        {
          assertion = !(needPrime && primeCfg.integratedType == "amd" && primeCfg.amdgpuBusId == null);
          message = "opts.nvidia.prime: integratedType=amd with PRIME requires amdgpuBusId.";
        }
      ];

      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;

      services.xserver.videoDrivers = videoDrivers;

      hardware.nvidia = {

        # https://discourse.nixos.org/t/there-are-3-nvidia-wiki-pages-for-nixos/64066/21
        # Do NOT enable this if you're using an Optimus (hybrid graphics) system
        modesetting.enable = !needPrime;

        open = cfg.open;
        powerManagement = {
          enable = cfg.powerManagement.enable;
          finegrained = cfg.powerManagement.finegrained;
        };

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # you may need to select the appropriate driver version for your specific GPU.
        package = cfg.package;
      }
      // primeModeAttrs
      // primeBusAttrs;
    }
  );
}
