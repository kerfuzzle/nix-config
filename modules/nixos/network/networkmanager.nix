{ config, lib, ... }:
let
  cfg = config.hostConfig.networkmanager;

  # Base config needed for all wireless networks
  mkBaseWirelessNetwork = id: rec {
    connection = {
      id = id;
      type = "wifi";
    };
    wifi = {
      ssid = "\$${id}_ssid";
      mode = "infrastructure";
    };
    ipv4.method = "auto";
    ipv6 = ipv4;

  };

  # Adds additonal config needed for a standard wpa-psk network
  mkStandardWirelessNetwork =
    id:
    (mkBaseWirelessNetwork id)
    // {
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-psk";
        psk = "\$${id}_psk";
      };
    };

  # Adds additonal config needed for a network with user authentication
  mkEapWirelessNetwork =
    id:
    (mkBaseWirelessNetwork id)
    // {
      wifi-security = {
        key-mgmt = "wpa-eap";
      };
      "802-1x" = {
        eap = "peap";
        identity = "\$${id}_identity";
        password = "\$${id}_password";
        phase2-auth = "mschapv2";
      };
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

    # Tell sops to create a file that contains variables for all of the network secrets
    sops.templates.ssid-list.content = lib.concatStringsSep "\n" (
      lib.concatLists [
        # Generate lines for standard networks
        (builtins.map (network: ''
          ${network}_ssid="${config.sops.placeholder."networks/${network}/ssid"}"
          ${network}_psk="${config.sops.placeholder."networks/${network}/psk"}"
        '') cfg.standardWirelessNetworks)
        # Generate lines for user auth networks
        (builtins.map (network: ''
          ${network}_ssid="${config.sops.placeholder."networks/${network}/ssid"}"
          ${network}_identity="${config.sops.placeholder."networks/${network}/identity"}"
          ${network}_password="${config.sops.placeholder."networks/${network}/password"}"
        '') cfg.eapWirelessNetworks)
      ]
    );

    networking.networkmanager = {
      enable = true;
      ensureProfiles = {
        # Point network manager to the enviroment file made by sops
        environmentFiles = [ config.sops.templates.ssid-list.path ];

        #secrets.entries = builtins.concatLists [
        # (builtins.map (network: {
        #     file = config.sops.secrets."networks/${network}/psk".path;
        #     matchId = network;
        #     matchSetting = "802-11-wireless-security";
        #     key = "psk";
        # }) cfg.standardWirelessNetworks)
        #];

        # Define profiles for both types of networks
        profiles = lib.mkMerge [
          (builtins.listToAttrs (
            lib.concatLists [
              (builtins.map (network: {
                name = network;
                value = mkStandardWirelessNetwork network;
              }) cfg.standardWirelessNetworks)
              (builtins.map (network: {
                name = network;
                value = mkEapWirelessNetwork network;
              }) cfg.eapWirelessNetworks)
            ]
          ))
        ];
      };
    };
  };
}
