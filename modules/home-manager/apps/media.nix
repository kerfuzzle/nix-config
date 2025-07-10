{ pkgs, ... }:
{
  home.packages = with pkgs; [
    obs-studio
    pcmanfm
    zathura
    swayimg
    mpv
    gimp
    libreoffice
    xournalpp
  ];
}
