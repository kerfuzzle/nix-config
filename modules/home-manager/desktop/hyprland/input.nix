{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "gb";
      scroll_method = "2fg";
      natural_scroll = true;
      sensitivity = -0.1;

      touchpad = {
        # Use number of fingers to determine press type instead of location
        clickfinger_behavior = true;
        # Make touchpad taps act as clicks
        tap-to-click = true;
      };
    };

    device = [
      {
        name = "corsair-corsair-gaming-harpoon-rgb-mouse";
        sensitivity = 1;
        natural_scroll = false;
      }
      {
        name = "corsair-corsair-harpoon-rgb-pro-gaming-mouse";
        sensitivity = 1;
        natural_scroll = false;
      }
    ];

  };
}
