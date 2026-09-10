{ lib, ... }:
let
  mkSimple = prop: regex: { ${prop} = regex; };
  mkWindowRule =
    {
      match ? [ ],
      exclude ? [ ],
      properties,
    }:
    {
      window-rule._children =
        (map (rule: {
          match._props = rule;
        }) match)
        ++ (map (rule: {
          exclude._props = rule;
        }) exclude)
        ++ lib.singleton properties;
    };
in
{
  wayland.windowManager.niri.settings._children = [
    (mkWindowRule {
      properties = {
        # Applies to all windows
        geometry-corner-radius = 5.;
        clip-to-geometry = true;
        draw-border-with-background = false;
        background-effect.blur = true;
      };
    })
    (mkWindowRule {
      match = lib.singleton { is-focused = false; };
      exclude = [
        # Stop these apps/titles from having inactive translucency
        (mkSimple "app-id" "org\\.pwmt\\.zathura")
        (mkSimple "app-id" "sioyek")
        (mkSimple "app-id" "texpresso")
        (mkSimple "title" "YouTube")
        (mkSimple "title" "\\.pdf")
        (mkSimple "title" "Apple.Music")
        (mkSimple "title" "^Picture-in-Picture")
      ];
      properties.opacity = 0.8;
    })
    (mkWindowRule {
      match = lib.singleton { is-floating = true; };
      properties.background-effect.xray = false;
    })
    (mkWindowRule {
      match = [
        {
          app-id = "Alacritty";
          title = "peaclock";
        }
        (mkSimple "app-id" "qalculate")
      ];
      properties = {
        open-floating = true;
        default-column-width.fixed = 520;
        default-window-height.fixed = 180;
        default-floating-position._props = {
          x = 30;
          y = 30;
          relative-to = "bottom-right";
        };
      };
    })
    (mkWindowRule {
      match = lib.singleton (mkSimple "app-id" "epsilon");
      properties.open-floating = true;
    })
    # thunderbird is weirdly sized by default
    (mkWindowRule {
      match = lib.singleton (mkSimple "app-id" "thunderbird");
      properties = {
        open-fullscreen = false;
        open-maximized-to-edges = false;
        open-floating = false;
      };
    })
    # Float firefox PiP
    (mkWindowRule {
      match = lib.singleton {
        app-id = "^firefox$";
        title = "^Picture-in-Picture$";
      };
      properties = {
        open-floating = true;
        default-column-width.proportion = 0.25;
        default-window-height.proportion = 0.25;
        default-floating-position._props = {
          x = 30;
          y = 30;
          relative-to = "bottom-right";
        };
      };
    })
    # Stop anki child windows from being huge
    (mkWindowRule {
      match = lib.singleton (mkSimple "app-id" "anki");
      exclude = [
        (mkSimple "title" "- Anki$")
        (mkSimple "title" "Checking")
        (mkSimple "title" "Syncing")
        (mkSimple "title" "Options")
        (mkSimple "title" "Rename")
        (mkSimple "title" "Export")
      ];
      properties = {
        default-column-width.proportion = 0.5;
        default-window-height.proportion = 1.0;
        open-fullscreen = false;
        open-maximized-to-edges = false;
        open-floating = false;
      };
    })
    # Make anki options window float
    (mkWindowRule {
      match = [
        {
          app-id = "anki";
          title = "Options";
        }
        {
          app-id = "anki";
          title = "Export";
        }
      ];
      properties = {
        default-column-width.fixed = 780;
        default-window-height.fixed = 975;
        open-fullscreen = false;
        open-maximized-to-edges = false;
        open-floating = true;
      };
    })
    # Make anki sync status reasonably sized
    (mkWindowRule {
      match = [
        {
          app-id = "anki";
          title = "Checking";
        }
        {
          app-id = "anki";
          title = "Syncing";
        }
        {
          app-id = "anki";
          title = "Rename";
        }
      ];
      properties = {
        open-floating = true;
        default-column-width.fixed = 400;
        default-window-height.fixed = 100;
      };
    })
  ];
}
