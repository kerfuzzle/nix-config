{
  outputs,
  config,
  lib,
  ...
}:
{
  imports = lib.custom.importAll ./.;

  sops = {
    secrets.github-access-token.sopsFile = lib.custom.configRoot + /secrets/misc.yaml;
    templates.access-token-prelude = {
      # Access token only has access to read public repositories. This avoids github rate limiting issues.
      content = ''
        				access-tokens = github.com=${config.sops.placeholder.github-access-token}
        			'';
      # Must be accessible to user as the nix evaluator does not run as root
      owner = config.hostConfig.username;
      mode = "0400";
    };
  };

  nixpkgs.overlays = outputs.overlays.all;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      # Automatically optimise store on rebuild
      auto-optimise-store = true;
    };

    # Automatically run garbage collection every day
    gc = {
      automatic = true;
      dates = "daily";
      # Delete generations more than 5 days old
      options = "--delete-older-than 5d";
    };

    # Inlclude the token config in nix.conf
    extraOptions = ''
      			!include ${config.sops.templates.access-token-prelude.path}
      		'';
  };

  # Set default time zone
  time.timeZone = "Europe/London";

  # Set GB locale
  i18n.defaultLocale = "en_GB.UTF-8";

  # Setup virtual console
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
    # Use config in initrd
    earlySetup = true;
  };
}
