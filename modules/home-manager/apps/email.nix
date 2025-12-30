{
  config,
  lib,
  ...
}:
let
  cfg = config.homeConfig.email;
in
{
  options.homeConfig.email.enable = lib.mkEnableOption "email client" // {
    default = true;
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles.${config.home.username} = {
        isDefault = true;
      };
      settings = {
        # Disable in app updates, managed by nix
        "app.update.enabled" = false;
        # Disable donation popup
        "app.donation.eoy.version.viewed" = 999;
        # Tracking prevention
        "privacy.globalprivacycontrol.enabled" = true;
        # Disable checking if thunderbird is default mail client
        "mail.shell.checkDefaultClient" = false;
      };
    };
  };
}
