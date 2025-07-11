{ lib, ... }:
{
  imports = [
    ./primary.nix
    ./root.nix
  ];

  users.mutableUsers = lib.mkDefault false;
}
