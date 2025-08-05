{ pkgs, hostConfig, ... }:
{
  home.packages =
    with pkgs;
    [
      # Calculator
      qalculate-gtk
      # Flashcards
      anki
    ]
    ++ (lib.optional hostConfig.printing.scanners.enable pkgs.simple-scan);
}
