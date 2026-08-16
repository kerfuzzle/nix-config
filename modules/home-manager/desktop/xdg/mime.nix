{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    handlr-regex
    # Replace xterm with default terminal
    (writeShellApplication {
      name = "xterm";
      runtimeInputs = [ handlr-regex ];
      text = ''handlr launch x-scheme-handler/terminal -- "$@"'';
    })
    # Replace xdg-open with handlr
    (writeShellApplication {
      name = "xdg-open";
      runtimeInputs = [ handlr-regex ];
      text = ''handlr open -- "$@"'';
    })
  ];

  xdg = {
    mime.enable = true;
    mimeApps =
      let
        # Converts into attrset with mime types as keys and applications as values, see https://github.com/spikespaz/dotfiles/blob/e157a2e30296c59e4d8078e0dcca02595569ae1e/users/jacob/mimeApps.nix
        invertAssociations =
          assoc:
          assoc
          |> (lib.mapAttrsToList mapMimeListToXDGAttrs)
          |> lib.flatten
          |> lib.zipAttrs;
        mapMimeListToXDGAttrs =
          name:
          map (mime: {
            ${mime} = "${name}.desktop";
          });
        associations = invertAssociations {
          "firefox" = [
            "text/html"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/about"
            "x-scheme-handler/unkown"
          ];
          "swayimg" = [
            "image/*"
            "image/bmp"
            "image/gif"
            "image/jpeg"
            "image/jpg"
            "image/pjpeg"
            "image/png"
            "image/svg+xml"
            "image/svg+xml-compressed"
            "image/tiff"
            "image/x-bmp"
            "image/x-gray"
            "image/x-icb"
            "image/x-ico"
            "image/x-pcx"
            "image/x-png"
            "image/x-portable-anymap"
            "image/x-portable-bitmap"
            "image/x-portable-graymap"
            "image/x-portable-pixmap"
            "image/x-xbitmap"
            "image/x-xpixmap"
          ];
          "mpv" = [
            "video/*"
            "audio/*"
            "application/mxf"
            "application/ogg"
            "application/sdp"
            "application/smil"
            "application/streamingmedia"
            "application/vnd.apple.mpegurl"
            "application/vnd.ms-asf"
            "application/vnd.rn-realmedia"
            "application/vnd.rn-realmedia-vbr"
            "application/x-cue"
            "application/x-extension-m4a"
            "application/x-extension-mp4"
            "application/x-matroska"
            "application/x-mpegurl"
            "application/x-ogg"
            "application/x-ogm"
            "application/x-ogm-audio"
            "application/x-ogm-video"
            "application/x-shorten"
            "application/x-smil"
            "application/x-streamingmedia"
            "audio/3gpp"
            "audio/3gpp2"
            "audio/AMR"
            "audio/aac"
            "audio/ac3"
            "audio/aiff"
            "audio/amr-wb"
            "audio/dv"
            "audio/eac3"
            "audio/flac"
            "audio/m3u"
            "audio/m4a"
            "audio/mp1"
            "audio/mp2"
            "audio/mp3"
            "audio/mp4"
            "audio/mpeg"
            "audio/mpeg2"
            "audio/mpeg3"
            "audio/mpegurl"
            "audio/mpg"
            "audio/musepack"
            "audio/ogg"
            "audio/opus"
            "audio/rn-mpeg"
            "audio/scpls"
            "audio/vnd.dolby.heaac.1"
            "audio/vnd.dolby.heaac.2"
            "audio/vnd.dts"
            "audio/vnd.dts.hd"
            "audio/vnd.rn-realaudio"
            "audio/vorbis"
            "audio/wav"
            "audio/webm"
            "audio/x-aac"
            "audio/x-adpcm"
            "audio/x-aiff"
            "audio/x-ape"
            "audio/x-m4a"
            "audio/x-matroska"
            "audio/x-mp1"
            "audio/x-mp2"
            "audio/x-mp3"
            "audio/x-mpegurl"
            "audio/x-mpg"
            "audio/x-ms-asf"
            "audio/x-ms-wma"
            "audio/x-musepack"
            "audio/x-pls"
            "audio/x-pn-au"
            "audio/x-pn-realaudio"
            "audio/x-pn-wav"
            "audio/x-pn-windows-pcm"
            "audio/x-realaudio"
            "audio/x-scpls"
            "audio/x-shorten"
            "audio/x-tta"
            "audio/x-vorbis"
            "audio/x-vorbis+ogg"
            "audio/x-wav"
            "audio/x-wavpack"
            "video/3gp"
            "video/3gpp"
            "video/3gpp2"
            "video/avi"
            "video/divx"
            "video/dv"
            "video/fli"
            "video/flv"
            "video/mkv"
            "video/mp2t"
            "video/mp4"
            "video/mp4v-es"
            "video/mpeg"
            "video/msvideo"
            "video/ogg"
            "video/quicktime"
            "video/vnd.divx"
            "video/vnd.mpegurl"
            "video/vnd.rn-realvideo"
            "video/webm"
            "video/x-avi"
            "video/x-flc"
            "video/x-flic"
            "video/x-flv"
            "video/x-m4v"
            "video/x-matroska"
            "video/x-mpeg2"
            "video/x-mpeg3"
            "video/x-ms-afs"
            "video/x-ms-asf"
            "video/x-ms-wmv"
            "video/x-ms-wmx"
            "video/x-ms-wvxvideo"
            "video/x-msvideo"
            "video/x-ogm"
            "video/x-ogm+ogg"
            "video/x-theora"
            "video/x-theora+ogg"
          ];
          "org.pwmt.zathura" = [
            "application/pdf"
            "application/epub"
          ];
          "nvim" = [
            "text/*"
            "text/plain"
            "application/json"
            "application/x-zerosize"
            "application/x-shellscript"
          ];
          "yazi" = [
            "inode/directory"
            "x-directory/normal"
            "application/zip"
            "application/x-zip*"
            "application/x-xz*"
            "application/x-tar*"
            "application/x-rar*"
            "application/x-7z*"
          ];
          "Alacritty" = [
            "x-scheme-handler/terminal"
          ];
          "discord" = [ "x-scheme-handler/discord" ];
          "com.github.xournalpp.xournalpp" = [
            "application/x-xopp"
            "application/x-xoj"
          ];
        };
      in
      {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      };
  };
}
