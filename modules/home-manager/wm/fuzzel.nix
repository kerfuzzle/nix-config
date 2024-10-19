{ config, ... }: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        prompt = "\"❯ \"";

        icons-enabled = false;

        horizontal-pad = 8;
				font = "monospace:size=10";
      };

      border = {
        radius = 0;
      };

      colors = with config.colorScheme.palette; {
	 	 		background = "${base00}ef";
				text = "${base05}ff";
				match = "${base0A}ff";
	 			selection = "${base03}ff";
	 			selection-text = "${base05}ff";
	  		selection-match = "${base0A}ff";
	  		border = "${base0D}ff";
			};
    };
  };
}
