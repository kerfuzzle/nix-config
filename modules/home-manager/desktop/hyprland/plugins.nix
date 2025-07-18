{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      inputs.hyprsplit.packages.${pkgs.system}.hyprsplit
    ];

    settings = {
      plugin = {
        hyprsplit = {
          num_workspaces = 5;
        };

        overview = {
          exitOnClick = true;
          exitOnSwitch = true;
          reverseSwipe = true;
          showEmptyWorkspace = false;
        };
      };
    };
  };
}
