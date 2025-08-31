{ ... }:
{
  stylix.targets.nvf.enable = false;
  programs.nvf = {
    enable = true;
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

      autocomplete.blink-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;

      git.enable = true;

      telescope.enable = true;

      dashboard.startify.enable = true;

      treesitter = {
        enable = true;
        context.enable = true;
      };

      statusline.lualine = {
        enable = true;
      };

      utility = {
        ccc.enable = true;
      };

      ui = {
        breadcrumbs.enable = true;
        noice.enable = true;
      };

      notify.nvim-notify = {
        enable = true;
        setupOpts.stages = "fade";
      };

      lsp = {
        enable = true;
        formatOnSave = true;
        trouble.enable = true;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        ts = {
          enable = true;
          lsp.enable = true;
          format.type = "biome";
        };
        nix = {
          enable = true;
          format = {
            enable = true;
            type = "nixfmt";
          };
          lsp = {
            enable = true;
            server = "nil";
          };
        };
        lua = {
          enable = true;
          lsp.enable = true;
        };
        html.enable = true;
        css.enable = true;
        python = {
          enable = true;
          lsp.enable = true;
        };
      };
    };
  };
}
