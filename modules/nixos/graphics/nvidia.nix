{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hostConfig.nvidia;
  mkBusIdOption =
    name:
    (lib.mkOption {
      example = "0000:01:00.0";
      type = lib.types.str;
      default = "";
      description = "BDF PCI bus ID for ${name} GPU, obtained with `nix shell nixpkgs#pciutils -c lspci -d ::03xx";
    });
in
{
  options.hostConfig.nvidia = {
    enable = lib.mkEnableOption "nvidia GPU support";
    beta = lib.mkEnableOption "nvidia beta drivers";
    hybrid = {
      enable = lib.mkEnableOption "support for hybrid graphics in laptops";
      nvidiaBdfBusId = mkBusIdOption "nvidia";
      intelBdfBusId = mkBusIdOption "intel";
      amdBdfBusId = mkBusIdOption "amd";
    };
  };

  config = lib.mkIf cfg.enable {
    # User space drivers are still proprietary
    allowedUnfreePkgs = [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      # Systemd power management
      powerManagement.enable = true;
      # Open source drivers are now recommened
      open = true;
      # Use beta/stable branch
      package =
        if cfg.beta then
          config.boot.kernelPackages.nvidiaPackages.beta
        else
          config.boot.kernelPackages.nvidiaPackages.stable;
      # GUI gpu info tool
      nvidiaSettings = true;
    };

    # Fixes suspend-then-hibernate
    # systemd.services = lib.mkIf config.hardware.nvidia.powerManagement.enable (
    #   let
    #     mkNvidiaSuspendService = state: sleepAction: {
    #       description = "NVIDIA system ${state} actions";
    #       path = [ pkgs.kbd ];
    #       serviceConfig = {
    #         Type = "oneshot";
    #         ExecStart = "${config.hardware.nvidia.package.out}/bin/nvidia-sleep.sh '${sleepAction}'";
    #       };
    #       before = [ "systemd-${state}.service" ];
    #       requiredBy = [ "systemd-${state}.service" ];
    #     };
    #   in
    #   {
    #     nvidia-suspend-then-hibernate = mkNvidiaSuspendService "suspend-then-hibernate" "suspend";
    #     # nvidia-hybrid-sleep = mkNvidiaSuspendService "hybrid-sleep" "hibernate";

    #     # Add after services to nvidia-resume service
    #     nvidia-resume = {
    #       after = [
    #         "systemd-suspend-then-hibernate.service"
    #         # "systemd-hybrid-sleep.service"
    #       ];
    #       requiredBy = [
    #         "systemd-suspend-then-hibernate.service"
    #         # "systemd-hybrid-sleep.service"
    #       ];
    #     };
    #   }
    # );
  };
}
