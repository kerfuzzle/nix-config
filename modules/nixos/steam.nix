{ lib, ... }: {
  allowedUnfree = [
    "steam"
    "steam-original"
    "steam-run"
  ];

  programs.steam = {
    enable = true;
  };
}
