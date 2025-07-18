{
  programs.wlogout = {
    enable = true;
    style = ./style.css;
    layout = [
      {
        label = "shutdown";
        text = "Shutdown";
        action = "poweroff";
      }
      {
        label = "lock";
        text = "Lock";
        action = "loginctl lock-session";
      }
      {
        label = "hibernate";
        text = "Hibernate";
        action = "systemctl hibernate";
      }
      {
        label = "reboot";
        text = "Reboot";
        action = "poweroff --reboot";
      }
      {
        label = "suspend";
        text = "Suspend";
        action = "systemctl suspend";
      }
      {
        label = "hyprland-exit";
        text = "Exit Hyprland";
        action = "hyprctl dispatch exit";
      }
    ];
  };
}
