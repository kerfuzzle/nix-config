{
  inputs,
  pkgs,
  nixosConfig,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  stylix.targets.nixvim.enable = false;
  programs.nixvim = {
    enable = false;
    defaultEditor = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "frappe";
      };
    };

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    clipboard.providers.wl-copy.enable = true;

    plugins = {
      lualine.enable = true;
      startify.enable = true;
      ccc.enable = true;
      telescope.enable = true;

      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "treesitter"; }
            { name = "nvim_lsp_signature_help"; }
          ];
        };
      };

      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          eslint.enable = true;
          nixd = {
            enable = true;
            settings.options =
              let
                inherit (nixosConfig.hostConfig) hostname;
              in
              {
                nixpkgs.expr = "(builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs";
                nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options";
                home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${hostname}.options.home-manager.users.type.getSubOptions []";
              };
          };
        };
      };

      lspkind = {
        enable = true;
        cmp.enable = true;
      };

      lsp-format.enable = true;

      typescript-tools.enable = true;

      treesitter = {
        enable = true;
        folding = false;
        nixvimInjections = true;
        nixGrammars = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;

        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      treesitter-context.enable = true;
    };
  };
}
