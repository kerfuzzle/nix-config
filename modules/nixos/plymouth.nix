{
  pkgs,
  config,
  lib,
  ...
}:
let
  jetBrainsMono = pkgs.nerd-fonts.jetbrains-mono;
in
{
  options.hostConfig.plymouth.enable = lib.mkEnableOption "plymouth" // {
    default = true;
  };

  config = lib.mkIf config.hostConfig.plymouth.enable {
    stylix.targets.plymouth.enable = false;
    boot = {
      plymouth = {
        enable = true;
        font = "${jetBrainsMono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
        extraConfig = ''
          DeviceScale=1
        '';
      };

      loader = {
        systemd-boot.consoleMode = "max";
        # Setting to this to zero means the menu does not show unless a key is held
        timeout = 0;
      };

      consoleLogLevel = 3;
      initrd = {
        verbose = false;
        # Load in stage 1 for LUKS
        systemd.enable = true;
      };
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };
  };
}
