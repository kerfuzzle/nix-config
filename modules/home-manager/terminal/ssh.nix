{
  config,
  lib,
  hostConfig,
  ...
}:
{
  programs.ssh = {
    enable = true;
    matchBlocks =
      # Setup aliases for tailscale devices as well as default ssh users
      (lib.mapAttrs (name: value: {
        inherit (value) user;
        hostname = value.ipv4;
        identityFile = config.sops.secrets."private-keys/kerfuzzle".path;
      }) hostConfig.tailscale.devices)
      // {
        "github.com" = {
          user = "git";
          identityFile = config.sops.secrets."private-keys/github".path;
        };
      };
  };

  sops.secrets = lib.mkIf config.homeConfig.sops.enable (
    lib.custom.mapListToAttrs (e: "private-keys/${e}")
      (e: {
        sopsFile = lib.custom.configRoot + /secrets/ssh.yaml;

        path = "${config.home.homeDirectory}/.ssh/id_${e}";
      })
      [
        "kerfuzzle"
        "backup"
        "github"
      ]
  );
}
