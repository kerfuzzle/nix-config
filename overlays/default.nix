{ inputs, lib, ... }:
rec {
  additions = final: _prev: {
    custom = import (lib.custom.configRoot + /pkgs) final.pkgs;
  };

  updates = _final: prev: {
    # statix = prev.statix.overrideAttrs (_old: rec {
    #   src = prev.fetchFromGitHub {
    #     owner = "oppiliappan";
    #     repo = "statix";
    #     rev = "e9df54ce918457f151d2e71993edeca1a7af0132";
    #     hash = "sha256-duH6Il124g+CdYX+HCqOGnpJxyxOCgWYcrcK0CBnA2M=";
    #   };

    #   cargoDeps = prev.pkgs.rustPlatform.importCargoLock {
    #     lockFile = src + "/Cargo.lock";
    #     allowBuiltinFetchGit = true;
    #   };
    # });
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpks-stable {
      inherit (final) system;
    };
  };

  all = [
    additions
    updates
    stable-packages
  ];
}
