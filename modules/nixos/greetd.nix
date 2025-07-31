{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hostConfig.greetd;
in
{
  options.hostConfig.greetd.enable = lib.mkEnableOption "greetd" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # Use tuigreet and remember the previous session and user
          # Desktop entries should already be created by hyprland and graphics/hybrid.nix
          command = "${lib.getExe pkgs.greetd.tuigreet} --time --remember --remember-session --asterisks";
          user = "greeter";
        };
      };
    };
  };
}
