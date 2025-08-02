{ lib, config, ... }:
{
  programs.git = {
    enable = true;
    userName = "kerfuzzle";
    userEmail = "58907164+kerfuzzle@users.noreply.github.com";

    signing = lib.mkIf config.homeConfig.sops.enable {
      signByDefault = true;
      format = "ssh";
      key = config.sops.secrets."private-keys/github".path;
    };
  };
}
