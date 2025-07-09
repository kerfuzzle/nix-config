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
