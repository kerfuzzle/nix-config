{ config, lib, ... }:
{
  sops.secrets."login/root-password" = {
    neededForUsers = true;
    sopsFile = lib.custom.configRoot + /secrets/login.yaml;
  };

  users.users.root.hashedPasswordFile = config.sops.secrets."login/root-password".path;
}
