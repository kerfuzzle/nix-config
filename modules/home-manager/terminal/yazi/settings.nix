{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.yazi.settings = {
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
            run = "${lib.getExe config.programs.nvf.settings.vim.build.finalPackage} -o \"$@\"";
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
        browser = [
          {
            run = "${lib.getExe config.programs.firefox.finalPackage} \"$@\"";
            desc = "Open in browser";
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
          use = [
            "edit"
            "browser"
          ];
        }
        # JSON
        {
          mime = "application/{json,ndjson}";
          use = [
            "edit"
            "browser"
          ];
        }
        # Image
        {
          mime = "image/*";
          use = [
            "open"
            "imageEdit"
            "browser"
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
          use = [
            "open"
            "browser"
          ];
        }
      ];
    };
  };
}
