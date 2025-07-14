let
  mkExtension = shortId: uuid: {
    name = uuid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "force_installed";
      default_area = "menupanel";
    };
  };
in
{
  programs.firefox.policies.ExtensionSettings = builtins.listToAttrs [
    # Adblock
    (mkExtension "ublock-origin" "uBlock0@raymondhill.net")
    # Skips youtube sponsor segements
    (mkExtension "sponsorblock" "sponsorBlocker@ajay.app")
    # Tab groups
    (mkExtension "simple-tab-groups" "simple-tab-groups@drive4ik")
    # Containers to seperate different accounts
    (
      (mkExtension "multi-account-containers" "@testpilot-containers")
      // {
        value.default_area = "navbar";
      }
    )
    # Tracker blocking
    (mkExtension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
    # Translates web pages
    (mkExtension "traduzir-paginas-web" "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}")
    # Strips tracking elements from URLs
    (mkExtension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
  ];
}
