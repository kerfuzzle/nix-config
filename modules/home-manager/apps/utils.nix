{ pkgs, hostConfig, ... }:
{
  home.packages =
    with pkgs;
    [
      # Calculator
      qalculate-gtk
      # Flashcards
      anki
      # Disk usage analyser
      qdirstat
    ]
    ++ (lib.optional hostConfig.printing.scanners.enable pkgs.simple-scan);
}
