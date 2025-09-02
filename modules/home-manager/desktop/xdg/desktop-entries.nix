{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.desktopEntries =
    let
      alacritty = lib.getExe config.programs.alacritty.package;
      mkTerminalLaunch = app: "${alacritty} -e ${app}";
      hiddenEntry = {
        name = "";
        exec = "";
        noDisplay = true;
      };
      hiddenEntries = [
        "pcmanfm-desktop-pref"
        "kvantummanager"
        "nixos-manual"
      ];
    in
    {
      kew = {
        name = "Kew";
        genericName = "Music Player";
        icon = "multimedia-audio-player";
        exec = lib.getExe pkgs.kew |> mkTerminalLaunch;
      };
      peaclock = {
        name = "Peaclock";
        icon = "preferences-system-time";
        exec = lib.getExe pkgs.peaclock |> mkTerminalLaunch;
      };
      yazi = {
        name = "Yazi";
        # icon = "file-manager";
        icon = lib.custom.configRoot + /resources/icons/yazi.svg;
        comment = "Blazing fast terminal file manager written in Rust, based on async I/O";
        terminal = true;
        exec = "yazi %u";
        type = "Application";
        mimeType = [ "inode/directory" ];
        categories = [
          "Utility"
          "Core"
          "System"
          "FileTools"
          "FileManager"
          "ConsoleOnly"
        ];
        settings = {
          TryExec = "yazi";
          Keywords = "File;Manager;Explorer;Browser;Launcher";
        };
      };
    }
    // (lib.genAttrs hiddenEntries (_: hiddenEntry));
}
