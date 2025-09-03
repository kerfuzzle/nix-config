{ nixosConfig, ... }:
{
  stylix.targets.nvf.enable = false;
  programs.nvf = {
    enable = true;
    defaultEditor = true;
    settings.vim = {
      options = {
        autoindent = true;
        shiftwidth = 2;
        tabstop = 2;
        expandtab = true;
      };

      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };

      theme = {
        enable = true;
        name = "catppuccin";
        style = "frappe";
      };

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
      };

      keymaps = [
        {
          key = "<c-p>";
          mode = [
            "n"
            "v"
          ];
          action = "\"+";
        }
      ];

      autocomplete.blink-cmp = {
        enable = true;
        setupOpts.completion.ghost_text.enabled = true;
      };

      autopairs.nvim-autopairs.enable = true;

      git.enable = true;

      telescope.enable = true;

      treesitter.context.enable = true;

      statusline.lualine.enable = true;

      utility = {
        diffview-nvim.enable = true;
      };

      visuals = {
        # Highlights word currently under cursor
        nvim-cursorline.enable = true;
        # Shows notifications and LSP progress in bottom right
        fidget-nvim.enable = true;
        # Idnetation guides
        indent-blankline.enable = true;
      };

      ui = {
        # Breadcrumbs at the top
        breadcrumbs.enable = true;
        # Highlight detected colour codes in correct colour
        colorizer.enable = true;
        # Highlight repeat uses of the same word
        illuminate.enable = true;
      };

      lsp = {
        enable = true;
        inlayHints.enable = true;
        trouble.enable = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        nix = {
          enable = true;
          format.type = "nixfmt";
          lsp = {
            server = "nixd";
            options =
              let
                inherit (nixosConfig.hostConfig) hostname;
              in
              {
                nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options";
                home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []";
              };
          };
        };
        ts.enable = true;
        lua.enable = true;
        html.enable = true;
        css.enable = true;
        python.enable = true;
      };
    };
  };
}
