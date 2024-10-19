{ lib, ... }: {
  allowedUnfree = [
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
  ];

  programs.steam = {
    enable = true;
  };
}
