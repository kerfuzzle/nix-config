{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Performance overlay
    mangohud
    # Minecraft launcher and mod manager
    prismlauncher
    # Celeste mod manager
    olympus
    # Launcher for GOG and Epic Games
    heroic
  ];
}
