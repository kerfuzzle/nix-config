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
      hotkey-overlay.skip-at-startup = true;
      screenshot-path = config.xdg.userDirs.pictures + "/screenshot_%d-%m-%Y_%H:%M:%S.png";

      cursor = {
        xcursor-size = 24;
        hide-when-typing = { };
        hide-after-inactive-ms = 3000;
      };

      blur.offset = 2;
      prefer-no-csd = true;

      _children = [
        {
          include = {
            _args = lib.singleton "/tmp/gpu.kdl";
            _props.optional = true;
          };
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
    };
  };
}
