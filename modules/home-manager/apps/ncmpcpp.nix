{ config, ... }: {
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = config.services.mpd.musicDirectory;
  };
}
