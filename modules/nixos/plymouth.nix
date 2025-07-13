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

      loader.systemd-boot.consoleMode = "max";
      loader.timeout = 0;

      consoleLogLevel = 0;
      initrd.verbose = false;
      initrd.systemd.enable = true;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };
  };
}
