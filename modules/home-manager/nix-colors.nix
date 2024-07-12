{ inputs, settings, ... }: {
  imports = [ inputs.nix-colors.homeManagerModules.default ];
  colorScheme = inputs.nix-colors.colorSchemes.${settings.colorScheme};
}
