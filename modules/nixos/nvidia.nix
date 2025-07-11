{ config, lib, ... }:
let
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
  options.nvidia = {
    enable = lib.mkEnableOption "nvidia GPU support";
    hybrid = {
      enable = lib.mkEnableOption "support for hybrid graphics in laptops";
      nvidiaBusId = mkBusIdOption "nvidia";
      intelBusId = mkBusIdOption "intel";
      amdBusId = mkBusIdOption "amd";
    };
  };

  config = lib.mkIf config.nvidia.enable {
    allowedUnfree = [
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

      prime = lib.mkIf config.nvidia.hybrid.enable {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        intelBusId = config.nvidia.hybrid.intelBusId;
        nvidiaBusId = config.nvidia.hybrid.nvidiaBusId;
        amdgpuBusId = config.nvidia.hybrid.amdBusId;
      };
    };

    programs.gamemode.enable = true;
  };
}
