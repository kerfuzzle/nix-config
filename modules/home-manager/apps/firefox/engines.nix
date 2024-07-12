{ config, pkgs, ...}: {
  programs.firefox.profiles.${config.home.username}.search.engines = let 
    nix-params = [
      {
        name = "type";
        value = "packages";
      }
      {
        name = "query";
        value = "{searchTerms}";
      }
      {
        name = "channel";
        value = "24.05";
      }
    ];
    prefix = "@";
    snowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  in {
    "Bing".metaData.hidden = true;
    "eBay".metaData.hidden = true;
    "Google".metaData.alias = "${prefix}g";

    "nixpkgs" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = nix-params;
        }
      ];
      icon = snowflake;
      definedAliases = ["${prefix}pkgs"];
    };

    "nix options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = nix-params;
        }
      ];
      icon = snowflake;
      definedAliases = ["${prefix}opts"];
    };

    "home-manger options" = {
      urls = [
        {
          template = "https://home-manager-options.extranix.com";
          params = [
            {
              name = "query";
              value = "{searchTerms}";
            }
            {
              name = "release";
              value = "master";
            }
          ];
        }
      ];
      iconUpdateUrl = "https://home-manager-options.extranix.com/images/favicon.png";
      updateInterval = 7 * 24 * 60 * 60 * 1000;
      definedAliases = ["${prefix}hopts"];
    };

    "nix wiki" = {
      urls = [
        {
          template = "https://wiki.nixos.org/w/index.php";
          params = [
            {
              name = "search";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = snowflake;
      definedAliases = ["${prefix}nwiki"];
    };
  };
}