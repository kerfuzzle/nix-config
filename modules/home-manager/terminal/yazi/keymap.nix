{ config, lib, ... }:
{
  programs.yazi.keymap = {
    mgr.prepend_keymap = [
      {
        on = "z";
        run = "plugin zoxide";
        desc = "Jump to a directory via zoxide";
      }
      {
        on = "Z";
        run = "plugin fzf";
        desc = "Jump to a file/directory via fzf";
      }
      {
        on = ";";
        run = "shell --orphan ${lib.getExe config.programs.alacritty.package}";
        desc = "Open shell in current directory";
      }
      {
        on = "C";
        run = "plugin ouch";
        desc = "Compress with ouch";
      }
      {
        on = [
          "d"
          "r"
        ];
        run = "plugin restore";
        desc = "Restore last deleted files/folders";
      }
      {
        on = [
          "d"
          "R"
        ];
        run = "shell --block -- clear && trash-restore ~";
        desc = "Restore deleted file (Interactive)";
      }
      {
        on = [
          "d"
          "d"
        ];
        run = "remove";
        desc = "Trash selected files";
      }
      {
        on = [
          "d"
          "p"
        ];
        run = "remove --permanently";
        desc = "Permanently delete selected files";
      }
      {
        on = "<C-y>";
        run = "plugin wl-clipboard";
        desc = "Copy the file to the system clipboard";
      }
      {
        on = "<Enter>";
        run = "plugin smart-enter";
        desc = "Enter the child directory, or open the file";
      }
      {
        on = "p";
        run = "plugin smart-paste";
        desc = "Paste into the hovered directory or CWD";
      }
      {
        on = [
          "g"
          "d"
        ];
        run = "cd ${config.xdg.userDirs.download}";
        desc = "Go to downloads";
      }
      {
        on = [
          "g"
          "f"
        ];
        run = "cd ${config.home.sessionVariables.FLAKE}";
        desc = "Go to Nix system flake";
      }
      {
        on = [
          "g"
          "s"
        ];
        run = "cd /mnt/share/";
        desc = "Go to network shares";
      }
      {
        on = [
          "g"
          "o"
        ];
        run = "cd ${config.xdg.userDirs.documents}";
        desc = "Go to documents";
      }
    ];
  };
}
