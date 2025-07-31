{
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
      # GUI gpu info tool
      nvidiaSettings = true;
    };
  };
}
