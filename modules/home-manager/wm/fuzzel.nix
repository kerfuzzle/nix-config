{ config, ... }: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        prompt = "> ";

        icons-enabled = false;

        horizontal-pad = 8;      
      };

      border = {
        radius = 0;
      };

      colors = with config.colorScheme.palette; {
        background = "${base01}ec";
        text = "${base05}FF";
        border = "${base06}ff";
      };
    };
  };
}
