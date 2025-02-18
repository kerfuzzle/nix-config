{ config, lib, pkgs, ... }: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        prompt = "\"❯ \"";

        icons-enabled = false;

        horizontal-pad = 8;
				font = lib.mkForce "monospace:size=10";

				terminal = "${pkgs.alacritty}/bin/alacritty -e";
      };

      border = {
        radius = 0;
      };
    };
  };
}
