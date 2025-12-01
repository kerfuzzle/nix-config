{
  pkgs,
  lib,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      window = {
        # Override stylix default
        opacity = lib.mkForce 0.7;
        padding = {
          x = 10;
          y = 10;
        };
        # Disable terminal apps from changing the window title
        dynamic_title = false;
      };

      scrolling = {
        history = 500;
      };

      # Handling of hyprlinks
      hints.enabled = [
        {
          # Use handlr to open in the correct application
          command = {
            program = lib.getExe pkgs.handlr-regex;
            args = [ "open" ];
          };
          hyperlinks = true;
          post_processing = true;
          regex = ''(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`\\\\]+'';
          persist = false;
          # Require ctrl click to avoid accidental clicks
          mouse = {
            enabled = true;
            mods = "Control";
          };
        }
      ];
    };
  };
}
