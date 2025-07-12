{
  description = "kerfuzzle's nix-config flake";

  inputs = {
    # Official nixpkgs sources
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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

    # Tiling Wayland compositor
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Automatic global theming
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Safer rm alternative
    rip2 = {
      url = "github:MilesCranmer/rip2";
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
      lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages."x86_64-linux".nixfmt-tree;

      homeManagerModules.default = ./modules/home-manager;
      nixosConfigurations = {
        kamabo = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs lib;
            settings = import ./hosts/kamabo/settings.nix;
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
