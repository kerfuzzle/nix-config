{ config, lib, ... }:
let
  cfg = config.hostConfig.networkmanager;

  mkWirelessNetwork = id: rec {
    connection = {
      id = id;
      type = "wifi";
    };
    wifi = {
      ssid = "\$${id}_ssid";
      mode = "infrastructure";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      auth-alg = "open";
      psk = "\$${id}_psk";
    };
    ipv4 = {
      method = "auto";
    };
    ipv6 = ipv4;
  };

  networkSecret = {
    sopsFile = lib.custom.configRoot + /secrets/networks.yaml;
  };
in
{
  options.hostConfig.networkmanager = {
    enable = lib.mkEnableOption "NetworkManager";
    standardWirelessNetworks = lib.mkOption {
      description = "Names of networks using just a WPA psk for authentication, added as entries to secrets/networks.yaml with `psk` and `ssid` attributes";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "network1"
        "network2"
      ];
    };
    eapWirelessNetworks = lib.mkOption {
      description = "Names of networks using EAP for user authentication, added as entries to secrets/networks.yaml with `ssid`, identity`, and `password` attributes";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "eduroam" ];
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = lib.mkMerge [
      # Define secrets for standard wireless networks
      (lib.mkMerge (
        builtins.map (network: {
          "networks/${network}/ssid" = networkSecret;
          "networks/${network}/psk" = networkSecret;
        }) cfg.standardWirelessNetworks
      ))
      # Define secrets for EAP wireless networks
      (lib.mkMerge (
        builtins.map (network: {
          "networks/${network}/ssid" = networkSecret;
          "networks/${network}/identity" = networkSecret;
          "networks/${network}/password" = networkSecret;
        }) cfg.eapWirelessNetworks
      ))
    ];

    sops.templates.ssid-list.content = lib.concatStringsSep "\n" (
      builtins.map (network: ''
        		${network}_ssid="${config.sops.placeholder."networks/${network}/ssid"}"
        		${network}_psk="${config.sops.placeholder."networks/${network}/psk"}"
        		'') cfg.standardWirelessNetworks
    );

    networking.networkmanager = {
      enable = true;
      ensureProfiles = {
        environmentFiles = [ config.sops.templates.ssid-list.path ];

        #secrets.entries = builtins.concatLists [
        #	(builtins.map (network: {
        #			file = config.sops.secrets."networks/${network}/psk".path;
        #			matchId = network;
        #			matchSetting = "802-11-wireless-security";
        #			key = "psk";
        #	}) cfg.standardWirelessNetworks)
        #];

        profiles = lib.mkMerge [
          (builtins.listToAttrs (
            builtins.map (network: {
              name = network;
              value = mkWirelessNetwork network;
            }) cfg.standardWirelessNetworks
          ))
        ];
      };
    };
  };
}
