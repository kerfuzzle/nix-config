{ config, lib, ... }:
let
  gamingConfig = config.hostConfig.gaming;
in
{
  options.hostConfig.gaming = {
    gamemode.enable = lib.mkEnableOption "gamemode command";
    steam.enable = lib.mkEnableOption "steam";
  };

  config = {
    allowedUnfree = lib.mkIf gamingConfig.steam.enable [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];

    programs.steam = lib.mkIf gamingConfig.steam.enable {
      enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = gamingConfig.gamemode.enable;
  };
}
