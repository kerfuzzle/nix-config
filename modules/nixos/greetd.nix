{
  config,
  lib,
  ...
}:
let
  hostConfig = config.hostConfig;
in
{
  options.hostConfig.greetd.enable = lib.mkEnableOption "greetd" // {
    default = true;
  };

  config = lib.mkIf config.hostConfig.greetd.enable {
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = lib.getExe config.programs.hyprland.package;
          user = config.users.users.${hostConfig.username}.name;
        };
        default_session = initial_session;
      };
    };
  };
}
