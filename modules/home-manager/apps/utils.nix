{ pkgs, hostConfig, ... }:
{
  allowedUnfreePkgs = [ "numworks-epsilon" ];
  home.packages =
    with pkgs;
    [
      # Calculator
      qalculate-gtk
      # Numworks Simulator
      numworks-epsilon
      # Flashcards
      anki
      # Disk usage analyser
      qdirstat
    ]
    ++ (lib.optional hostConfig.printing.scanners.enable pkgs.simple-scan);
}
