{ config, ... }:
{
  programs.firefox.policies = rec {
    # Updates are managed by nix
    DisableAppUpdate = true;

    # Force download directory to match the xdg defined dir
    DefaultDownloadDirectory = config.xdg.userDirs.download;
    DownloadDirectory = DefaultDownloadDirectory;
    PromptForDownloadLocation = false;

    # Telemetry
    DisableTelemetry = true;
    DisableFirefoxStudies = true;

    # Disable firefox account features
    DisableFirefoxAccounts = true;
    DisableAccounts = true;
    DisablePocket = true;

    # Tracking Protection
    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };

    # Disable password manager
    PasswordManagerEnabled = false;
    OfferToSaveLogins = false;

    # Disable features that wouldn't work
    DisableFirefoxScreenshots = true;
    DisableSetDesktopBackground = true;

    # Disable annoying pages on first launch and after an update
    SkipTermsOfUse = true;
    OverrideFirstRunPage = "";
    OverridePostUpdatePage = "";

    # Search Suggestions
    FirefoxSuggest = {
      WebSuggestions = false;
      SponsoredSuggestions = false;
      ImproveSuggest = false;
    };
    FirefoxHome = {
      Search = true;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
    };

    # Misc
    DontCheckDefaultBrowser = true;
    DisableProfileImport = true;
    NoDefaultBookmarks = true;

    # Override specific preferences for all profiles
    Preferences =
      let
        lock = value: {
          Value = value;
          Status = "locked";
        };
      in
      {
        # Enable userChrome.css
        "toolkit.legacyUserProfileCustomizations.stylesheets" = lock true;
        # Enable Global Privacy Control
        "privacy.globalprivacycontrol.enabled" = lock true;
        # Disable the weirdly named and annoying search engine dropdown
        "browser.urlbar.scotchBonnet.enableOverride" = lock false;
        # Disable warning when visiting about:config
        "browser.aboutConfig.showWarning" = lock false;
        # Prevent the browser from closing when the last tab is closed
        "browser.tabs.closeWindowWithLastTab" = lock false;
        # Disable firefox view
        "browser.tabs.firefox-view" = lock false;
        # Disable form autofill
        "browser.formfill.enable" = lock false;
        # Disable search suggestions
        "browser.search.suggest.enabled" = lock false;
        "browser.search.suggest.enabled.private" = lock false;
        "browser.urlbar.suggest.searches" = lock false;
        "browser.urlbar.suggest.importantDates" = lock false;
        "browser.topsites.contile.enable" = lock false;
        # Disable AI chat features
        "browser.ml.chat.enabled" = lock false;
        "browser.ml.chat.shortcuts" = lock false;
        "browser.ml.chat.shortcuts.custom" = lock false;
        "browser.ml.chat.sidebar" = lock false;
        "browser.ml.chat.menu" = lock false;
        "browser.ml.chat.page" = lock false;
        "browser.ml.enable" = lock false;
        "extensions.ml.enabled" = lock false;
        # Disable AI tab groups
        "browser.tabs.groups.smart.enabled" = lock false;
        "browser.tabs.groups.smart.optin" = lock false;
        "browser.tabs.groups.smart.userEnabled" = lock false;
        # Clean up new tab page
        "browser.newtabpage.activity-stream.feeds.section.topstories" = lock false;
        "browser.newtabpage.activity-stream.feeds.snippets" = lock false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock false;
        "browser.newtabpage.activity-stream.showSponsored" = lock false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock false;
      };
  };
}
