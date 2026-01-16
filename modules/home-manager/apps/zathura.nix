{ config, lib, ... }:
{
  programs.zathura = {
    enable = true;
    options =
      let
        inherit (config.lib.stylix) colors;
        getColorCh = colorName: channel: colors."${colorName}-rgb-${channel}";
        rgb = color: "rgb(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"})";
      in
      {
        # Open document zoomed to page width
        adjust-open = "width";
        # Make shift-click trigger SyncTeX
        synctex-edit-modifier = "shift";
        # Make the window title just display the filename instead of the whole path
        window-title-basename = true;

        recolor-darkcolor = lib.mkForce (rgb "base05");
      };
  };
}
