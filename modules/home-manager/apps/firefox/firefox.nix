{ config, pkgs, ... }: let 
  locked-false = {
    Value = false;
    Status = "locked";
  };

  locked-true = {
    Value = true;
    Status = "locked";
  };

  downloadDir = "${config.home.homeDirectory}/downloads";

  userChromeCss = ./another-oneline.css;
in {
  imports = [ ./engines.nix ];
  programs.firefox = {
    enable = true;

    policies = {
      DisableAppUpdate = true;
      DefaultDownloadDirectory = downloadDir;
      DownloadDirecyory = downloadDir;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableSetDesktopBackground = true;
      PromptForDownloadLocation = false;
    };
    
    profiles."${config.home.username}" = {
      userChrome = builtins.readFile userChromeCss;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.urlbar.update2" = false;
        "browser.topsites.contile.enabled" = false;
        "browser.formfill.enable" = false;
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
      };

      search = {
        force = true;
        default = "DuckDuckGo";
        # Engines are in engines.nix
      };
    };
  };
}
