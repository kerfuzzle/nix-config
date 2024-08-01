{ lib, ... }: {
  allowedUnfree = [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
  };

  programs.gamemode.enable = true;
}
