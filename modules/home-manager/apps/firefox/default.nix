{ config, pkgs, ... }:
{
  imports = [
    ./policies.nix
    ./engines.nix
    ./extensions.nix
  ];

  stylix.targets.firefox.profileNames = [ config.home.username ];

  programs.firefox = {
    enable = true;

    profiles."${config.home.username}" = {
      userChrome = builtins.readFile ./another-oneline.css;

      settings = {
        # See policies.nix for system wide settings
        # Restore previous session on startup;
        "browser.startup.page" = 3;
        # Disable bookmarks bar
        "browser.toolbars.bookmarks.visibility" = "never";
      };

      search = {
        force = true;
        default = "ddg";
        # See engines.nix for search custom search engines
      };
    };
  };
}
