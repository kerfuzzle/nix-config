{ config, lib, ... }:
let
  nvidiaConfig = config.hostConfig.nvidia;
  mkBusIdOption =
    name:
    (lib.mkOption {
      example = "PCI:1:0:0";
      type = lib.types.str;
      default = "";
      description = "PCI bus ID for ${name} GPU, obtained with `nix shell nixpkgs#pciutils -c lspci -d ::03xx";
    });
in
{
  options.hostConfig.nvidia = {
    enable = lib.mkEnableOption "nvidia GPU support";
    hybrid = {
      enable = lib.mkEnableOption "support for hybrid graphics in laptops";
      nvidiaBusId = mkBusIdOption "nvidia";
      intelBusId = mkBusIdOption "intel";
      amdBusId = mkBusIdOption "amd";
    };
  };

  config = lib.mkIf nvidiaConfig.enable {
    allowedUnfreePkgs = [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
    ];
    hardware.graphics.enable = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;

      prime = lib.mkIf nvidiaConfig.hybrid.enable {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = nvidiaConfig.hybrid.intelBusId;
        nvidiaBusId = nvidiaConfig.hybrid.nvidiaBusId;
        amdgpuBusId = nvidiaConfig.hybrid.amdBusId;
      };
    };
  };
}
