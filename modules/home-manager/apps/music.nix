{ pkgs, ... }: {
  home.packages = with pkgs; [
    cider
    musikcube
  ];
}
