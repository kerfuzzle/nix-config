with builtins; let
  ext = shortId: uuid: {
    name = uuid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "force_installed";
    };
  };
in
  listToAttrs [
    (ext "ublock-origin" "uBlock0@raymondhill.net")
    (ext "sponsorblock" "sponsorBlocker@ajay.app")
    (ext "simple-tab-groups" "simple-tab-groups@drive4ik")
  ]

