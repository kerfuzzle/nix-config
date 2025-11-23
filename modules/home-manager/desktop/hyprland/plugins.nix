{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.hyprsplit.packages.${pkgs.stdenv.hostPlatform.system}.hyprsplit
    ];

    settings = {
      plugin = {
        hyprsplit = {
          # Five workspaces per monitor
          num_workspaces = 5;
        };
      };
    };
  };
}
