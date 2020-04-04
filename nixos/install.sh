#!/bin/sh

NIXOS_CONFIGURATION_URL=https://raw.githubusercontent.com/maxdeviant/dotfiles/master/nixos/configuration.nix

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

if [ -b "$1" ]; then
    BLOCK_DEV=$1

    echo "Preparing to install NixOS on $BLOCK_DEV..."

    #
    # 2.2.1. UEFI (GPT)
    #

    echo "Partitioning drive..."

    parted "$BLOCK_DEV" -- mklabel gpt

    parted "$BLOCK_DEV" -- mkpart primary 512MiB -8GiB
    NIXOS_PARTITION="${BLOCK_DEV}p1"

    parted "$BLOCK_DEV" -- mkpart primary linux-swap -8GiB 100%
    SWAP_PARTITION="${BLOCK_DEV}p2"

    parted "$BLOCK_DEV" -- mkpart ESP fat32 1MiB 512MiB
    parted "$BLOCK_DEV" -- set 3 boot on
    BOOT_PARTITION="${BLOCK_DEV}p3"

    #
    # 2.2.3. Formatting
    #

    echo "Formatting partitions..."

    mkfs.ext4 -L nixos "$NIXOS_PARTITION"
    mkswap -L swap "$SWAP_PARTITION"
    mkfs.fat -F 32 -n boot "$BOOT_PARTITION"

    #
    # 2.3. Installing
    #

    echo "Mounting filesystems..."

    mount "$NIXOS_PARTITION" /mnt

    mkdir -p /mnt/boot
    mount "$BOOT_PARTITION" /mnt/boot

    echo "Generating default NixOS configuration..."
    nixos generate-config --root /mnt

    echo "Applying NixOS configuration from $NIXOS_CONFIGURATION_URL..."
    curl -o /mnt/etc/nixos/configuration.nix $NIXOS_CONFIGURATION_URL

    echo "Starting the NixOS install..."
    nixos-install
else
    echo "Usage: $0 /dev/<BLOCK_DEV>"
fi
