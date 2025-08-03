{ lib, config, ... }:
{
  programs.git = {
    enable = true;
    userName = "kerfuzzle";
    userEmail = "58907164+kerfuzzle@users.noreply.github.com";

    signing = lib.mkIf config.homeConfig.sops.enable {
      signByDefault = true;
      format = "ssh";
      # Specify private key, although docs suggest public key, this
      # is just used by a key agent to find the private key so it works
      # to just specify the private key
      key = config.sops.secrets."private-keys/github".path;
    };
  };
}
