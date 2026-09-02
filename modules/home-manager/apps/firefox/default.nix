{ lib, config, ... }:
{
  imports = lib.custom.importAll ./.;

  stylix.targets.firefox.profileNames = [ config.home.username ];

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";

    profiles."${config.home.username}" = {
      userChrome = builtins.readFile ./FoxOne-chrome.css;
      userContent = builtins.readFile ./FoxOne-content.css;

      settings = {
        # See policies.nix for system wide settings
        # Restore previous session on startup;
        "browser.startup.page" = 3;
        # Disable bookmarks bar
        "browser.toolbars.bookmarks.visibility" = "never";
        # Enable autoscrolling
        "general.autoScroll" = true;
      };

      search = {
        force = true;
        default = "ddg";
        # See engines.nix for search custom search engines
      };
    };
  };
}
