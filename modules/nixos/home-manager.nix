{ settings, inputs, ... }: {
  home-manager = {
    extraSpecialArgs = {inherit inputs settings;};
    users = {
      "${settings.username}" = { ... }: {
        imports = [
          (import ../../hosts/${settings.hostname}/home.nix)
          inputs.self.outputs.homeManagerModules.default
        ];
      };
    };
  };
}
