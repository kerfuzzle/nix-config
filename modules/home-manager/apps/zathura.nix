{ config, lib, ... }:
{
  programs.zathura = {
    enable = true;
    options =
      let
        inherit (config.lib.stylix) colors;
        getColorCh = colorName: channel: colors."${colorName}-rgb-${channel}";
        rgb = color: ''rgb(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"})'';
      in
      {
        # Open document zoomed to page width
        adjust-open = "width";
        # Make shift-click trigger SyncTeX
        synctex-edit-modifier = "shift";

        recolor-darkcolor = lib.mkForce (rgb "base05");
      };
  };
}
