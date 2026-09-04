{ lib, ... }: {
  wayland.windowManager.niri.settings.input = {
    disable-power-key-handling = { };

    keyboard.xkb = {
      layout = "gb";
      options = lib.concatStringsSep "," [
        "caps:escape"
        "shift:both_capslock"
      ];
    };

    touchpad = {
      # Make touchpad taps act as clicks
      tap = { };
      # Use two fingers for scrolling
      scroll-method = "two-finger";
      # Use number of fingers to determine press type instead of location
      click-method = "clickfinger";

      scroll-factor = 0.9;
    };
  };
}
