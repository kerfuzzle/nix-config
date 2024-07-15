{ pkgs }: let 
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
  "Google".metaData.hidden = true;

  "nixpkgs" = {
    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = nix-params;
      }
    ];
    icon = snowflake;
    definedAliases = ["${prefix}np"];
  };

  "nix options" = {
    urls = [
      {
        template = "https://search.nixos.org/options";
        params = nix-params;
      }
    ];
    icon = snowflake;
    definedAliases = ["${prefix}no"];
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
    definedAliases = ["${prefix}nw"];
  };

  "MDN" = {
    urls = [
      {
        template = "https://developer.mozilla.org/en-US/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "https://developer.mozilla.org/static/img/favicon32.png";
    definedAliases = ["${prefix}mdn"];
  };
}
