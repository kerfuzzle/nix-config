{ lib, ... }: {
  imports = lib.custom.importAll ./.;

  programs.niri.settings = {
    # debug.ignore-drm-device = "/dev/dri/dgpu";
    prefer-no-csd = true;

    window-rules = [
      {
        geometry-corner-radius = lib.genAttrs [ "bottom-left" "bottom-right" "top-left" "top-right" ] (
          _: 5.0
        );
        clip-to-geometry = true;
      }
      #{
      #  matches = lib.singleton { is-focused = false; };
      #  opacity = 0.8;
      #}
    ];

    layout = {
      border.width = 2;
      focus-ring.width = 2;
      gaps = 5;
      struts = {
        left = 4;
        right = 4;
        top = 4;
        bottom = 4;
      };
    };
  };
}
