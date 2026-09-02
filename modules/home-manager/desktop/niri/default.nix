{ lib, ... }: {
  imports = lib.custom.importAll ./.;

  wayland.windowManager.niri = {
    enable = true;
    settings = {
      debug.ignore-drm-device = "/dev/dri/dgpu";
      prefer-no-csd = true;
      cursor.xcursor-size = 24;
      hotkey-overlay.skip-at-startup = true;

      _children = [
        {
          window-rule._children = lib.singleton {
            geometry-corner-radius = 5.;
            clip-to-geometry = true;
          };
        }
        {
          window-rule._children = [
            {
              match._props = {
                is-focused = false;
              };
            }
            { opacity = 0.8; }
          ];
        }
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

      blur = {
        passes = 6;
        offset = 3.;
        noise = 0.02;
      };
    };
  };
}
