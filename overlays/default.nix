{ inputs, lib, ... }:
rec {
  additions = final: _prev: {
    custom = import (lib.custom.configRoot + /pkgs) final.pkgs;
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpks-stable {
      system = final.system;
    };
  };

  all = [
    additions
    stable-packages
  ];
}
