{ lib, ... }:
{
  # Useful for specifying a file relative to the root of the repository
  configRoot = ../.;

  # Maps a list to an attrset, using the function namef and valuef to generate the name and value of each entry
  mapListToAttrs =
    namef: valuef: list:
    builtins.listToAttrs (
      builtins.map (e: {
        name = namef e;
        value = valuef e;
      }) list
    );

  # Creates a list to import all of the directories and nix files in a given directory
  importAll =
    with lib;
    let
      isValidImport =
        name: type:
        type == "directory"
        || (type == "regular" && name != "default.nix" && strings.hasSuffix ".nix" name);
    in
    dir: dir |> builtins.readDir |> filterAttrs isValidImport |> attrNames |> map (n: dir + "/${n}");

  # Split a string at multiple delimiters, discarding the delimiters
  splitStringByDelimiters =
    delimiters: lib.splitStringBy (_: curr: builtins.elem curr delimiters) false;
}
