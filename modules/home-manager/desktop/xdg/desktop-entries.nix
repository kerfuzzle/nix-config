{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Desktop entries found in ~/.nix-profile/share/applications
  xdg.desktopEntries =
    let
      alacritty = lib.getExe config.programs.alacritty.package;
      mkTerminalLaunch = pkg: "${alacritty} -T ${lib.getName pkg} -e ${lib.getExe pkg}";
      hiddenEntry = {
        name = "";
        exec = "";
        noDisplay = true;
      };
      hiddenEntries = [
        "pcmanfm-desktop-pref"
        "kvantummanager"
        "nixos-manual"
        "org.fcitx.fcitx5-migrator"
        "kbd-layout-viewer5"
      ];
    in
    {
      kew = {
        name = "Kew";
        genericName = "Music Player";
        icon = "multimedia-audio-player";
        exec = mkTerminalLaunch pkgs.kew;
      };
      peaclock = {
        name = "Peaclock";
        icon = "preferences-system-time";
        exec = mkTerminalLaunch pkgs.peaclock;
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
