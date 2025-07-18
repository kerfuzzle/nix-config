{ inputs, lib, ... }:
let
  additions = final: _prev: {
    custom = import (lib.custom.configRoot + /pkgs) final.pkgs;
  };

  stable-packages = final: _prev: {
    stable = import inputs.nixpks-stable {
      system = final.system;
    };
  };
in
{
  default =
    final: prev:
    lib.mergeAttrsList (
      builtins.map (overlay: (overlay final prev)) [
        additions
        stable-packages
      ]
    );
}
