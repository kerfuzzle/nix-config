{ pkgs, ...}: {
  fonts.fontconfig = {
    defaultFonts = {
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };
  
  home.packages = with pkgs; [
      font-awesome
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
