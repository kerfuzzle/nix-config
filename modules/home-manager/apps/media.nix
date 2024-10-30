{ pkgs, ... }: {
  home.packages = with pkgs; [
    obs-studio
    nautilus
		zathura
		swayimg
  ];
}
