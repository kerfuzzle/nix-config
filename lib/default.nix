{ lib, ... }:
{
  configRoot = ../.;
  mapListToAttrs =
    namef: valuef: list:
    builtins.listToAttrs (
      builtins.map (e: {
        name = namef e;
        value = valuef e;
      })
    );
}
