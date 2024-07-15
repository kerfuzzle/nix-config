{ config, ... }: {
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = config.services.mpd.musicDirectory;
    settings = {
      song_window_title_format = "ncmpcpp";
    };
  };
}
