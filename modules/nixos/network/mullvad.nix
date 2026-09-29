{ lib, ... }: {
  services.mullvad-vpn = {
    enable = true;
    gui.enable = true;
  };

  sops.secrets.mullvad-account = {
    sopsFile = lib.custom.configRoot + /secrets/misc.yaml;
    path = "/etc/mullvad-vpn/account-history.json";
  };
}
