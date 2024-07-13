{ settings, pkgs, ... }: {
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };  
    flake = /home/${settings.username}/nix;
  };

  environment.systemPackages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
