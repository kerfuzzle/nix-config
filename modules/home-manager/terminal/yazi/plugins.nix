{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard
    trash-cli
    ouch
    mediainfo
    imagemagick
  ];

  programs.yazi = {
    plugins = {
      inherit (pkgs.yaziPlugins)
        smart-enter
        smart-paste
        wl-clipboard
        restore
        ouch
        mediainfo
        git
        ;
    };

    initLua = ''
      require("zoxide"):setup {
        update_db = true,
      }

      require("git"):setup {
        order = 1500,
      }
    '';

    settings.plugin =
      let
        mkMimeMediainfo = mime: {
          inherit mime;
          run = "mediainfo";
        };

      in
      rec {
        prepend_preloaders = builtins.map mkMimeMediainfo [
          "{audio,video,image}/*"
          "application/subrip"
          "application/postscript"
          "application/illustrator"
          "application/dvb.ait"
          "application/vnd.adobe.illustrator"
          "image/x-eps"
          "application/eps"
          "*.{ai,eps,ait}"
        ];
        prepend_previewers = prepend_preloaders;
        prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
            group = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
      };
  };
}
