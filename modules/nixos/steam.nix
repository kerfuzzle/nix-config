{ config, lib, ... }:
{
  options.steam.enable = lib.mkEnableOption "steam";

  config = lib.mkIf config.steam.enable {
    allowedUnfree = [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
}
