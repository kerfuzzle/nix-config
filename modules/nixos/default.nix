{
  outputs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./network
    ./users
    ./home-manager.nix
    ./allow-unfree.nix
    ./gaming.nix
    ./pipewire.nix
    ./plymouth.nix
    ./rip2.nix
    ./stylix.nix
    ./greetd.nix
    ./kernel.nix
    ./cachix.nix
    ./droidcam.nix
    ./tablet.nix
    ./zsh.nix
    ./impermenance.nix
    ./nvidia.nix
    ./sops.nix
    ./sudo.nix
    ./lanzaboote.nix
    ./tlp.nix
    ./hyprland.nix
  ];

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
}
