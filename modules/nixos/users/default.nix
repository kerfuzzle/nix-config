{ lib, ... }:
{
  imports = lib.custom.importAll ./.;

  # Use declaritive users only, disallows creation of other users
  users.mutableUsers = lib.mkDefault false;
}
