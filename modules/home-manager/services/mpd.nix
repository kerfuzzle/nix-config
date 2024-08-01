{ config, ... }: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/music";
    network.startWhenNeeded = true;
  };

  services.mpdris2.enable = true;
}
