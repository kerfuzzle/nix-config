{
  lib,
  config,
  hostConfig,
  ...
}:
{
  imports = lib.custom.importAll ./.;

  wayland.windowManager.niri = {
    enable = true;
    settings = {
      debug.ignore-drm-device = "/dev/dri/dgpu";
      prefer-no-csd = true;
      cursor = {
        xcursor-size = 24;
        hide-when-typing = { };
        hide-after-inactive-ms = 3000;
      };
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
        {
          output = {
            _args = [ "eDP-1" ];
            mode = "1920x1080@60.003";
            position._props = {
              x = 0;
              y = 0;
            };
            hot-corners.off = { };
          };
        }
        {
          output =
            let
              width = 3840;
            in
            rec {
              _args = [ "Microstep MAG274UPF CC2H974200553" ];
              mode = "${toString width}x2160@144.000";
              position._props = {
                x =
                  if hostConfig.hyprland.mainMonitorLeft then builtins.div width scale |> builtins.floor else 1920;
                y = 0;
              };
              scale = 1.5;
              hot-corners.off = { };
            };
        }
      ];

      layout = with config.lib.stylix.colors.withHashtag; {
        border = {
          active-color = base0D;
          width = 2;
        };
        focus-ring.off = { };
        gaps = 5;
        struts = {
          left = 4;
          right = 4;
          top = 4;
          bottom = 4;
        };
      };
    };
  };
}
