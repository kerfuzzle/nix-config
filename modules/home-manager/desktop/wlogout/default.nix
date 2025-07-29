{
  programs.wlogout = {
    enable = true;
    style = ./style.css;
    layout = [
      {
        label = "hibernate";
        text = "Hibernate";
        action = "systemctl hibernate";
        keybind = "1";
      }
      {
        label = "lock";
        text = "Lock";
        action = "loginctl lock-session";
        keybind = "2";
      }
      {
        label = "shutdown";
        text = "Shutdown";
        action = "poweroff";
        keybind = "3";
      }
      {
        label = "reboot";
        text = "Reboot";
        action = "poweroff --reboot";
        keybind = "4";
      }
      {
        label = "suspend";
        text = "Suspend";
        action = "systemctl suspend";
        keybind = "5";
      }
      {
        label = "hyprland-exit";
        text = "Exit Hyprland";
        action = "hyprctl dispatch exit";
        keybind = "6";
      }
    ];
  };
}
