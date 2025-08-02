{
  description = "kerfuzzle's nix-config flake";

  inputs = {
    # Official nixpkgs sources
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Pin to this revision, see https://github.com/NixOS/nixpkgs/issues/429271
    nixpkgs.url = "github:nixos/nixpkgs/7fd36ee82c0275fb545775cc5e4d30542899511d";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

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
    impermanence.url = "github:nix-community/impermanence";

    # Secure boot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
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
        hyprutils.follows = "hyprland/hyprutils";
        hyprlang.follows = "hyprland/hyprlang";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        hyprgraphics.follows = "hyprland/hyprgraphics";
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

    # Hyprland Plugins
    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    hyprsplit = {
      url = "github:shezdy/hyprsplit";
      inputs.hyprland.follows = "hyprland";
    };

    # Automatic global theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # base16 colour schemes
    nix-colors.url = "github:misterio77/nix-colors";

    # home-manager module to configure nvim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib.extend (
        self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; } // inputs.home-manager.lib
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
              lib = nixpkgs.lib;
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
