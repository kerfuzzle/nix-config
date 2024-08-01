{ pkgs, ... }: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding = {
          right = 1;
        };
      };
      display = {
        separator = " ›  ";
      };
      modules = [
        "break"
        {
          type = "os";
          key = "OS  ";
          keyColor = "31";
        }
        {
          type = "kernel";
          key = "KER ";
          keyColor = "31";
        }
        {
          type = "packages";
          format = "{} (nixpkgs)";
          key = "PKG ";
          keyColor = "32";
        }
        {
          type = "shell";
          key = "SH  ";
          keyColor = "32";
        }
        {
          type = "terminal";
          key = "TER ";
          keyColor = "33";
        }
        {
          type = "wm";
          key = "WM  ";
          keyColor = "33";
        }
        {
          type = "cpu";
          key = "CPU ";
          keyColor = "34";
        }
        {
          type = "gpu";
          key = "GPU ";
          keyColor = "34";
        }
        {
          type = "memory";
          key = "MEM ";
          keyColor = "35";
        }
        {
          type = "sound";
          key = "AUD ";
          keyColor = "35";
        }
        "break"
      ];
    };
  };
}
