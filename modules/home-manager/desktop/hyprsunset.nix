{ inputs, pkgs, ... }:
{
  services.hyprsunset = {
    enable = false;
    extraArgs = [ "--verbose" ];
    package = inputs.hyprsunset.packages.${pkgs.system}.hyprsunset;
    transitions = {
      sunrise = {
        calendar = "*-*-* 06:00:00";
        requests = [
          [ "identity" ]
        ];
      };

      sunset = {
        calendar = "*-*-* 21:00:00";
        requests = [
          [
            "temperature"
            "3000"
          ]
        ];
      };
    };
  };
}
