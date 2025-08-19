{ config, lib, ... }:
let
  cfg = config.hostConfig.smbClient;

  # this line prevents hanging on network split
  automountOpts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

  smbSecret = {
    sopsFile = lib.custom.configRoot + /secrets/smbShares.yaml;
  };
in
{
  options.hostConfig.smbClient = {
    enable = lib.mkEnableOption {
      description = "Whether the system should use CIFS to connect to SMB shares";
    };

    shares = lib.mkOption {
      description = "List of shares to be used, each should have a corresponding entry in secrets/smbShares.yaml";
      type =
        with lib.types;
        listOf (submodule {
          options = {
            name = lib.mkOption {
              description = "The name of the share, corresponds to an entry name in secrets/smbShares.yaml";
              type = lib.types.str;
            };
            device = lib.mkOption {
              description = "Device to connect to";
              type = lib.types.str;
            };
          };
        });
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Define secrets for all shares
    sops.secrets = lib.mkMerge (
      builtins.map (share: {
        "smbShares/${share.name}/username" = smbSecret;
        "smbShares/${share.name}/password" = smbSecret;
      }) cfg.shares
    );

    # Use sops to create secret files for each of the shares
    sops.templates = lib.custom.mapListToAttrs (share: "${share.name}_smb_secrets") (share: {
      content = ''
        username=${config.sops.placeholder."smbShares/${share.name}/username"}
        password=${config.sops.placeholder."smbShares/${share.name}/password"}
      '';
    }) cfg.shares;

    # Create fileSystem entries for each of the shares
    fileSystems = lib.custom.mapListToAttrs (share: "${share.name}_smb") (share: {
      device = share.device;
      fsType = "cifs";
      mountPoint = "/mnt/share/${share.name}";
      options = [
        automountOpts
        # Specify sops secrets file
        "credentials=${config.sops.templates."${share.name}_smb_secrets".path}"
        # Mount as main user
        "uid=${toString config.users.users.${config.hostConfig.username}.uid}"
      ];
    }) cfg.shares;
  };
}
