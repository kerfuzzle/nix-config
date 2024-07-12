{ pkgs, ... }: let
  jetBrainsMono = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ];};
in  {
  boot = {
    plymouth = {
      enable = true;
      font = "${jetBrainsMono}/share/fonts/truetype/NerdFonts/JetBrainsMonoNerdFont-Regular.ttf";
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
}
