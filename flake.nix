{
  description = "kerfuzzle's nix config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		stylix = {
			url = "github:danth/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		rip2 = {
			url = "github:MilesCranmer/rip2";
			inputs.nixpkgs.follows = "nixpkgs";
		};

    nix-colors.url = "github:misterio77/nix-colors";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... } @inputs: {
    homeManagerModules.default = ./modules/home-manager;
    nixosConfigurations = {
      kamabo = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          settings = import ./hosts/kamabo/settings.nix; 
        };
        
        modules = [
          ./hosts/kamabo/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
					inputs.stylix.nixosModules.stylix
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

    #homeConfigurations = {
    #  kerfuzzle = inputs.home-manager.lib.homeManagerConfiguration {
    #    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    #    modules = [ ./hosts/kamabo/home.nix ];
    #  };
    #};
  };
}
