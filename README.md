## Installation
1. Clone repo
2. Specify LUKS encryption key `echo "SuperSecretKey" > /tmp/secret.key`
3. Partition and format the drive `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --flake nix-config#hostname`
4. Check the drive was paritioned correctly with `lsblk`
5. Move nix-config into the persist subvolume for safekeeping so that it doesn't get deleted when we reboot after installing `sudo mv nix-config /mnt/persist/`
6. Install the system with `sudo nixos-install --root /mnt --flake /mnt/persist/nix-config#hostname`
7. Wait for the system to install
8. Reboot
9. Move nix-config from persist into a home directory `sudo mv /persist/nix-config ~/`


## Recovery
### Impermanence
In the event of an impermanence issue, recovery can be performed using a backup of the root partition
1. Boot into an installer image
2. Run `sudo cryptsetup luksOpen /dev/path-to-drive nixenc`
3. Mount the main btrfs volume `sudo mount /dev/mapper/nixenc /mnt`
4. Create a new root subvolume as the script was not able to `sudo btrfs subvolume create /mnt/root`
5. Navigate into `/mnt/old_roots/`
6. Find the most recent root backup `cd` into it
7. Run `sudo cp -r * ../../root/` to move the root files into the new subvolume
8. Unmount the btrfs volume `sudo umount /mnt`
9. Reboot the system into the main installation

### chroot
1. Follow steps 1 and 2 as in the [installation section](#installation)
2. Mount the drive and subvolumes using `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode mount --flake nix-config#hostname`. (Note the `mode` flag is only set to `mount` here as we don't want to wipe the drive)
3. Run `sudo nixos-enter --root /mnt` to chroot into the system
4. Carry out needed recovery.
5. To rebuild the system, run `nixos-rebuild boot --flake /home/USERNAME/nixos-config#hostname` (Note the `boot` subcommand over `switch` as we cannot switch to a new generation when chroot'ed, `boot` rebuilds and sets the new generation as the default boot option).
6. Reboot the system into the main installation
