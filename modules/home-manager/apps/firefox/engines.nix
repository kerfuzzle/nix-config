{
  pkgs,
  config,
  lib,
  ...
}:
let
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
      value = "unstable";
    }
  ];
  prefix = "@";
  snowflake = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  weekly = 7 * 24 * 60 * 60 * 1000;
in
{
  programs.firefox.profiles.${config.home.username}.search.engines = {
    bing.metaData.hidden = true;
    ebay.metaData.hidden = true;
    google.metaData.hidden = true;
    wikipedia.metaData.alias = "${prefix}w";

    nixpkgs = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params = nix-params;
        }
      ];
      icon = snowflake;
      definedAliases = [ "${prefix}np" ];
    };

    "TeX nixpkgs" = {
      urls = [
        {
          template = "https://search.nixos.org/packages";
          params =
            nix-params
            ++ (lib.singleton {
              name = "buckets";
              value = ''{"package_attr_set":["texlivePackages"],"package_license_set":[],"package_maintainers_set":[],"package_teams_set":[],"package_platforms":[]}'';
            });
        }
      ];
      icon = snowflake;
      definedAliases = [ "${prefix}tnp" ];
    };

    "NixOS Options" = {
      urls = [
        {
          template = "https://search.nixos.org/options";
          params = nix-params;
        }
      ];
      icon = snowflake;
      definedAliases = [ "${prefix}no" ];
    };

    "home-manager Options" = {
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
      icon = "https://home-manager-options.extranix.com/images/favicon.png";
      updateInterval = weekly;
      definedAliases = [ "${prefix}ho" ];
    };

    "NixOS Wiki" = {
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
      definedAliases = [ "${prefix}nw" ];
    };

    noogle = {
      urls = [
        {
          template = "https://noogle.dev/q";
          params = [
            {
              name = "term";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      definedAliases = [ "${prefix}ng" ];
      icon = snowflake;
    };

    MDN = {
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
      icon = "https://developer.mozilla.org/favicon.svg";
      updateInterval = weekly;
      definedAliases = [ "${prefix}mdn" ];
    };

    GitHub = {
      urls = [
        {
          template = "https://github.com/search";
          params = [
            {
              name = "q";
              value = "{searchTerms}";
            }
            {
              name = "type";
              value = "code";
            }
          ];
        }
      ];
      icon = "https://github.githubassets.com/favicons/favicon-dark.svg";
      updateInterval = weekly;
      definedAliases = [ "${prefix}gh" ];
    };

    WolframAlpha = {
      urls = [
        {
          template = "https://www.wolframalpha.com/input";
          params = [
            {
              name = "i";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "https://www.wolframalpha.com/_next/static/images/favicon_1zbE9hjk.ico";
      updateInterval = weekly;
      definedAliases = [ "${prefix}wa" ];
    };

    youtube = {
      urls = [
        {
          template = "https://www.youtube.com/results";
          params = [
            {
              name = "search_query";
              value = "{searchTerms}";
            }
          ];
        }
      ];
      icon = "https://www.youtube.com/s/desktop/00d073cd/img/logos/favicon_32x32.png";
      updateInterval = weekly;
      definedAliases = [ "${prefix}yt" ];
    };
  };
}
