{ settings, ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        disable_loading_bar = true;
      };
      background = [
        {
          path = settings.wallpaper;
          blur_passes = 2;
          blur_size = 5;
          brightness = 0.6;
        }
      ];

      label = [
        {
          text = "$TIME";
          text_align = "center";
          font_size = 120;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
        {
          text = "<i>$USER@kamabo</i>";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 510";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          size = "200, 30";
          position = "0, -40";
          fade_on_empty = true;
          fade_timeout = 1000;
          hide_input = false;
          outline_thickness = 4;
          inner_color = "rgb(255, 255, 255)";
          outer_color = "rgb(133, 146, 137)";
          check_color = "rgb(219,188,127)";
          fail_color = "rgb(230,126,128)";
          capslock_color = "rgb(127,187,179)";
          placeholder_text = "<i>password</i>";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        }
      ];
    };
  };
}
