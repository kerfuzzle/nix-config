{ config, ... }:
{
  services.mpd = {
    enable = false;
    musicDirectory = "${config.home.homeDirectory}/music";
    network.startWhenNeeded = true;
  };

  services.mpdris2.enable = false;
}
