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
          "float on"
          "center on"
          "size 50% 50%"
        ];
      in
      {
        # Automatically resize and move Picture-in-Picture windows
        "match:class firefox, match:title Picture-in-Picture" = [
          "float on"
          "pin on"
          "size 25% 25%"
          "move 100%-w-20 100%-w-20"
          "keep_aspect_ratio on"
          "opaque on"
        ];
        "match:class org.pwmt.zathura" = [
          "idle_inhibit focus"
        ];
        "match:class sioyek" = [
          "idle_inhibit focus"
        ];
        # Auto resize qalculate
        "match:class qalculate.*" = [
          "float on"
          "size 30% 30%"
          "move 100%-w-20 100%-w-20"
        ];
        # Auto resize epsilon
        "match:class epsilon" = [
          "float on"
          "center on"
          "keep_aspect_ratio on"
        ];
        # Steam window that isn't the main window or just a dropdown menu
        "match:class steam, match:title negative:(Steam)|()" = [
          "float on"
          "center on"
          "size 50% 50%"
          "opaque on"
        ];
        # Swappy colour picker
        "match:class swappy, match:title negative:swappy" = [
          "center on"
        ];
        # peaclock CLI clock
        "match:class Alacritty, match:title peaclock" = [
          "float on"
          "size 520 180"
        ];
        # Float and make file select dialogues a more reasonable size
        "match:title Open Files" = floatCenterResize;
        "match:title File Upload" = floatCenterResize;
        "match:title Save As" = floatCenterResize;
        "match:title Save Image" = floatCenterResize;
      }
    ))
    # Disable unfocus transparency for some applications
    ++ builtins.map (e: "opaque on, " + e) [
      "match:class firefox, match:title (.*)(- YouTube)(.*)"
      # For some reason the title here uses a "no-break space" so use `.` to specify any single character
      "match:class firefox, match:title (.*)(Apple.Music)(.*)"
      "match:class firefox, match:title (.*)(\\.pdf)(.*)"
      "match:class org.pwmt.zathura"
      "match:class sioyek"
      "match:class discord"
      "match:class Code"
      "match:class .texpresso-wrapped"
    ];
}
