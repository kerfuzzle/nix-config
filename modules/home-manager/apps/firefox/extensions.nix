let
  mkExtension = shortId: uuid: pinned: {
    name = uuid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "force_installed";
      default_area = if pinned then "navbar" else "menupanel";
    };
  };
in
{
  programs.firefox.policies.ExtensionSettings = builtins.listToAttrs [
    # Adblock
    (mkExtension "ublock-origin" "uBlock0@raymondhill.net" false)
    # Skips youtube sponsor segements
    (mkExtension "sponsorblock" "sponsorBlocker@ajay.app" false)
    # Tab groups
    (mkExtension "simple-tab-groups" "simple-tab-groups@drive4ik" true)
    # Containers to seperate different accounts
    (mkExtension "multi-account-containers" "@testpilot-containers" false)
    # Translates web pages
    (mkExtension "traduzir-paginas-web" "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" false)
    # Strips tracking elements from URLs
    (mkExtension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}" false)
  ];
}
