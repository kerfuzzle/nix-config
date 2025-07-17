{ config, lib, ... }:
let
  hostConfig = config.hostConfig;
in
{
  options.hostConfig.impermanence = {
    enable = lib.mkEnableOption "impermanence";
    oldRootCount = lib.mkOption {
      description = "How many old roots should be backed up";
      type = lib.types.ints.positive;
      default = 5;
      example = 10;
    };
  };

  config = lib.mkIf hostConfig.impermanence.enable {
    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = with lib.lists; [
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/ssh"
      ]
			++ (optional config.hardware.bluetooth.enable "/var/lib/bluetooth")
			++ (optional config.networking.networkmanager.enable "/etc/NetworkManager/system-connections")
			++ (optional config.boot.lanzaboote.enable config.boot.lanzaboote.pkiBundle)
			++ (optional config.services.tailscale.enable "/var/lib/tailscale");

      files = [
        "/etc/machine-id"
      ];
    };

    boot.initrd.systemd.services.recreate-root = {
      description = "Roll over by backing up old root and then creating a new root";

      wantedBy = [ "initrd.target" ];
      requires = [ "initrd-root-device.target" ];
      after = [
        "initrd-root-device.target"
        "local-fs-pre.target"
      ];
      before = [
        "sysroot.mount"
        "create-needed-for-boot-dirs.service"
      ];

      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";

      script = ''
        				mkdir /btrfs_tmp
        				mount /dev/mapper/nixenc /btrfs_tmp
        				# Check if there is a root to backup
        				if [[ -e /btrfs_tmp/root ]]; then
        					mkdir -p /btrfs_tmp/old_roots
        					timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
        					mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        				fi

        				delete_subvolume_recursively() {
        					IFS=$'\n'
        					# cut filters the output of the subvolume list to only be the path
        					for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
        						delete_subvolume_recursively "/btrfs_tmp/$i"
        					done
        					# Actually delete the subvolume
        					btrfs subvolume delete "$1"
        				}
        				
        				# Keep only the 5 most recent root backups
        				for i in $(ls -t -1 /btrfs_tmp/old_roots/ | tail +${
              toString (hostConfig.impermanence.oldRootCount + 1)
            }); do
        					delete_subvolume_recursively "/btrfs_tmp/old_roots/$i"
        				done
        				
        				# Create a new subolume in the mounted root
        				btrfs subvolume create /btrfs_tmp/root
        				# Unmount since we are done
        				umount /btrfs_tmp
        			'';
    };
  };
}
