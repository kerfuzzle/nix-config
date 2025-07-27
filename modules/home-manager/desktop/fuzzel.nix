{
  config,
  lib,
  ...
}:
{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        prompt = "\"❯ \"";
        # Size fonts depending on the monitors DPI
        dpi-aware = "yes";
        # Uses stylix icon theme by default
        icons-enabled = true;
        horizontal-pad = 8;
        vertical-pad = 8;
        inner-pad = 3;
        # Override font specified by stylix
        font = lib.mkForce "monospace:size=10";
        use-bold = true;
        terminal = "${lib.getExe config.programs.alacritty.package} -e";
      };

      border = {
        radius = 10;
        width = 3;
      };
    };
  };
}
