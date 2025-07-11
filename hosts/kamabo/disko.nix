{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  lib,
  ...
}:
let
  makeSubvolume =
    {
      mountpoint,
      atime ? false,
    }:
    {
      inherit mountpoint;
      mountOptions = [
        "compress=zstd"
        "discard=async"
      ] ++ (lib.lists.optional (!atime) "noatime");
    };
in
{
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "512M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "nixenc";
              # Use interactive password entry
              passwordFile = "/tmp/secret.key";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = (makeSubvolume { mountpoint = "/"; });
                  "/home" = (
                    makeSubvolume {
                      mountpoint = "/home";
                      atime = true;
                    }
                  );
                  "/nix" = (makeSubvolume { mountpoint = "/nix"; });
                  "/persist" = (makeSubvolume { mountpoint = "/persist"; });
                  "/var/log" = (makeSubvolume { mountpoint = "/var/log"; });
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "20G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
}
