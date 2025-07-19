{ config, lib, ... }:
let
  cfg = config.homeConfig.xdg;
in
{
  options.homeConfig.xdg =
    let
      mkXdgDirOption =
        name: default:
        lib.mkOption rec {
          inherit default;
          type = lib.types.str;
          description = "Location of the XDG ${name} directory relative to the home directory";
          example = default;
        };
    in
    {
      configDir = mkXdgDirOption "configuration" ".config";
      cacheDir = mkXdgDirOption "cache" ".cache";
      dataDir = mkXdgDirOption "data" ".local/share";
      stateDir = mkXdgDirOption "state" ".local/state";
    };

  config = {
    xdg =
      let
        homeDir = config.home.homeDirectory;
      in
      {
        enable = true;

        configHome = homeDir + "/${cfg.configDir}";
        cacheHome = homeDir + "/${cfg.cacheDir}";
        dataHome = homeDir + "/${cfg.dataDir}";
        stateHome = homeDir + "/${cfg.stateDir}";

        userDirs = {
          enable = true;
          # Automatically create directories if they don't exist
          createDirectories = true;
          music = homeDir + "/media/music";
          videos = homeDir + "/media/videos";
          pictures = homeDir + "/media/images";
          download = homeDir + "/downloads";
          documents = homeDir + "/documents";

          # Unused, need to be set to null otherwise directories will be created at the default paths
          publicShare = null;
          templates = null;
          desktop = null;
        };

        mime.enable = true;
        mimeApps =
          let
            # Converts into attrset with mime types as keys and applications as values, see https://github.com/spikespaz/dotfiles/blob/e157a2e30296c59e4d8078e0dcca02595569ae1e/users/jacob/mimeApps.nix
            invertAssociations =
              assoc: assoc |> (lib.mapAttrsToList mapMimeListToXDGAttrs) |> lib.flatten |> lib.zipAttrs;
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
              ];
              "mpv" = [
                "video/*"
                "application/x-extension-m4a"
                "application/x-extension-mp4"
                "application/x-matroska"
                "application/x-mpegurl"
                "application/x-streamingmedia"
              ];
              "org.pwmt.zathura" = [
                "application/pdf"
                "application/epub"
              ];
              "nvim" = [
                "text/*"
                "text/plain"
                "application/x-zerosize"
                "application/x-shellscript"
              ];
              "yazi" = [
                "inode/directory"
                "x-directory/normal"
                "application/zip"
                "application/x-zip"
                "application/x-zip-compressed"
                "application/x-xz"
                "application/x-xz-compressed-tar"
                "application/x-tar"
                "application/x-rar"
                "application/x-rar-compressed"
                "application/x-7z-compressed"
                "application/x-7z-compressed-tar"
              ];
              "discord" = [ "x-scheme-handler/discord" ];
              "com.github.xournalpp.xournalpp.desktop" = [
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
  };
}
