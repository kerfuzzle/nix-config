{ lib, ... }:
let
  ruleToString = name: value: (builtins.map (v: "${v}, ${name}") value);
  # Hyprland only allows window rules to specify a singular rule per a set of selection parameters
  # This converts from an attrset of selection parameters each with a list of rules to the hyprland format
  convertWindowRules = windowRules: windowRules |> lib.mapAttrsToList ruleToString |> lib.concatLists;
in
{
  wayland.windowManager.hyprland.settings.windowrule =
    (convertWindowRules (
      let
        floatCenterResize = [
          "float"
          "center"
          "size 50% 50%"
        ];
      in
      {
        # Automatically resize and move Picture-in-Picture windows
        "class: firefox, title:Picture-in-Picture" = [
          "float"
          "pin"
          "size 25% 25%"
          "move 100%-w-20 100%-w-20"
          "prop keepaspectratio"
          "prop opaque"
        ];
        # Auto resize qalculate
        "class: qalculate.*" = [
          "float"
          "size 30% 30%"
          "move 100%-w-20 100%-w-20"
        ];
        # Steam window that isn't the main window or just a dropdown menu
        "class: steam, title: negative:(Steam)|()" = [
          "float"
          "center"
          "size: 50% 50%"
          "prop opaque"
        ];
        # Swappy colour picker
        "class: swappy, title: negative:swappy" = [
          "center"
        ];
        # peaclock CLI clock
        "class: Alacritty, title: peaclock" = [
          "float"
          "size: 520 180"
        ];
        # Float and make file select dialogues a more reasonable size
        "title: Open Files" = floatCenterResize;
        "title: File Upload" = floatCenterResize;
        "title: Save As" = floatCenterResize;
        "title: Save Image" = floatCenterResize;
      }
    ))
    # Disable unfocus transparency for some applications
    ++ builtins.map (e: "prop opaque, " + e) [
      "class:firefox, title:(.*)(- YouTube)(.*)"
      # For some reason the title here uses a "no-break space" so use `.` to specify any single character
      "class:firefox, title:(.*)(Apple.Music)(.*)"
      "class:firefox, title:(.*)(\\.pdf)(.*)"
      "class:org.pwmt.zathura"
      "class:discord"
      "class:Code"
      "class:.texpresso-wrapped"
    ];
}
