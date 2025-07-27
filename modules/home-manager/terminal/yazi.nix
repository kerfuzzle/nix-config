{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard
    trash-cli
    ouch
  ];

  programs.yazi = {
    enable = true;

    plugins = {
      inherit (pkgs.yaziPlugins)
        smart-enter
        smart-paste
        wl-clipboard
        restore
        ouch
        ;
    };
    keymap = {
      mgr.prepend_keymap = [
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

    settings = {
      mgr = {
        linemode = "size";
      };
      opener =
        let
          # Use handlr-regex instead of xdg-open as it supports wildcard mime types
          handlr = lib.getExe pkgs.handlr-regex;
          gimp = lib.getExe pkgs.gimp;
        in
        {
          edit = [
            {
              run = "nvim -o \"$@\"";
              desc = "Edit with nvim";
              block = true;
              for = "unix";
            }
          ];
          open = [
            {
              run = "${handlr} open \"$1\"";
              desc = "Open";
              orphan = true;
              for = "unix";
            }
          ];
          imageEdit = [
            {
              run = "${gimp} \"$@\"";
              desc = "Edit with GIMP";
              orphan = true;
            }
          ];
        };
      open = {
        rules = [
          # Folder
          {
            name = "*/";
            use = [
              "edit"
              "open"
            ];
          }
          # Text
          {
            mime = "text/*";
            use = [ "edit" ];
          }
          # JSON
          {
            mime = "application/{json,ndjson}";
            use = [ "edit" ];
          }
          # Image
          {
            mime = "image/*";
            use = [
              "open"
              "imageEdit"
            ];
          }
          # Media
          {
            mime = "{audio,video}/*";
            use = [ "play" ];
          }
          # Formats that get mistaken as an archive
          {
            name = "*.{docx,pptx,xlsx}";
            use = [ "open" ];
          }
          # Archives
          {
            mime = "application/{zip,rar,7z*,tar,xz}";
            use = [
              "extract"
              "open"
            ];
          }
          # Empty file
          {
            mime = "inode/empty";
            use = [ "edit" ];
          }
          # Fallback
          {
            name = "*";
            use = [ "open" ];
          }
        ];
      };
    };
  };
}
