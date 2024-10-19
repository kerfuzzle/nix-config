{ inputs, pkgs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
			enable = true;
			settings = {
				flavour = "frappe";
			};
		};

    opts = {
			number = true;
			shiftwidth = 2;
			tabstop = 2;
			expandtab = false;
    };

    plugins = {
      lualine.enable = true;
      startify.enable = true;
      ccc.enable = true;

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
			cmp-nvim-lsp.enable = true;
			cmp-nvim-lsp-signature-help.enable = true;
      cmp-treesitter.enable = true;
      
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
					eslint.enable = true;
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
