{ config, ... }:
{
  config.boot.loader = {
    # Only use if lanzaboote is disabled
    systemd-boot.enable = !config.hostConfig.lanzaboote.enable;
    # Ensure the bootloader can modify efi variables
    efi.canTouchEfiVariables = true;
  };
}
