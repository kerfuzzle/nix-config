{
  description = "kerfuzzle's nix-config flake";

  inputs = {
    # Official nixpkgs sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    # Managing user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declaritive disk paritioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ephemeral system roots
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Secure boot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # -- Hypr Ecosystem
    # Doesn't follow nixpkgs to avoid caching issues
    hyprland.url = "github:hyprwm/Hyprland";

    # Wallpaper
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        aquamarine.follows = "hyprland/aquamarine";
        hyprutils.follows = "hyprland/hyprutils";
        hyprlang.follows = "hyprland/hyprlang";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprwire.follows = "hyprland/hyprwire";
      };
    };

    # Idle daemon
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        hyprutils.follows = "hyprland/hyprutils";
        hyprlang.follows = "hyprland/hyprlang";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };

    # Blue light filter
    hyprsunset = {
      url = "github:hyprwm/hyprsunset";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        hyprutils.follows = "hyprland/hyprutils";
        hyprlang.follows = "hyprland/hyprlang";
        hyprland-protocols.follows = "hyprland/hyprland-protocols";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };

    # Screen lock
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprutils.follows = "hyprland/hyprutils";
        hyprlang.follows = "hyprland/hyprlang";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
      };
    };

    # Automatic global theming
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # base16 colour schemes
    nix-colors.url = "github:misterio77/nix-colors";

    # home-manager modules to configure nvim
    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kew = {
      url = "github:ravachol/kew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib.extend (
        _: _: { custom = import ./lib { inherit (nixpkgs) lib; }; } // inputs.home-manager.lib
      );
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages."x86_64-linux".nixfmt-tree;
      overlays = import ./overlays { inherit inputs lib; };

      homeManagerModules.default = ./modules/home-manager;
      nixosConfigurations = {
        kamabo = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs lib;
          };

          modules = [
            inputs.disko.nixosModules.default
            (import ./hosts/kamabo/disko.nix {
              device = "/dev/nvme0n1";
              inherit (nixpkgs) lib;
            })

            ./hosts/kamabo/configuration.nix
            ./modules/nixos

            inputs.lanzaboote.nixosModules.lanzaboote
            inputs.impermanence.nixosModules.impermanence
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
            inputs.sops-nix.nixosModules.sops
          ];
        };
        tentatek = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            settings = import ./hosts/tentatek/settings.nix;
          };

          modules = [
            ./hosts/tentatek/configuration.nix
            ./modules/nixos
            inputs.home-manager.nixosModules.default
            inputs.stylix.nixosModules.stylix
          ];
        };
      };
    };
}
