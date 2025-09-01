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

      autocomplete.nvim-cmp.enable = true;
      autopairs.nvim-autopairs.enable = true;

      git.enable = true;

      telescope.enable = true;

      treesitter.context.enable = true;

      statusline.lualine.enable = true;

      utility = {
        diffview-nvim.enable = true;
      };

      visuals = {
        nvim-cursorline.enable = true;
        fidget-nvim.enable = true;
        indent-blankline.enable = true;
      };

      ui = {
        noice.enable = false;
        borders.enable = false;
        breadcrumbs.enable = true;
        colorizer.enable = true;
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
        ts.enable = true;
        nix = {
          enable = true;
          format.type = "nixfmt";
        };
        lua.enable = true;
        html.enable = true;
        css.enable = true;
        python.enable = true;
      };
    };
  };
}
