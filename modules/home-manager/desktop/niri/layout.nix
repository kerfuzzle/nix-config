{ config, ... }:
{
  wayland.windowManager.niri.settings.layout = with config.lib.stylix.colors.withHashtag; {
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
}
