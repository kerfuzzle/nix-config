{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homeConfig.xdg;
in
{
  imports = [
    ./mime.nix
  ];

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

        desktopEntries =
          let
            alacritty = lib.getExe config.programs.alacritty.package;
            mkTerminalLaunch = app: "${alacritty} -e ${app}";
          in
          {
            kew = {
              name = "kew";
              exec = lib.getExe pkgs.kew |> mkTerminalLaunch;
            };
          };
      };
  };
}
