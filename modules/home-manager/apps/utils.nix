{ pkgs, hostConfig, ... }:
{
  home.packages =
    with pkgs;
    [
      qalculate-gtk
      anki
    ]
    ++ (lib.optional hostConfig.printing.scanners.enable pkgs.simple-scan);
}
