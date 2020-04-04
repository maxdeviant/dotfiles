#!/usr/bin/env bash

NIXOS_CONFIGURATION_URL=https://raw.githubusercontent.com/maxdeviant/dotfiles/master/nixos/configuration.nix
SWAP_SIZE_IN_GB=8

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

if [ -b "$1" ]; then
    BLOCK_DEV=$1

    if [[ $* == *--dry-run* ]]; then
        RUN=echo

        echo "Performing a dry run!"
    else
        RUN=''
    fi

    if [[ "$BLOCK_DEV" == *"nvme"* ]]; then
        IS_NVME=1
    else
        IS_NVME=0
    fi

    echo "Preparing to install NixOS on $BLOCK_DEV..."

    #
    # 2.2.1. UEFI (GPT)
    #

    echo "Partitioning drive..."

    if [ $IS_NVME -eq 1 ]; then
        PARTITION_PREFIX=p
    else
        PARTITION_PREFIX=''
    fi

    $RUN parted "$BLOCK_DEV" -- mklabel gpt

    $RUN parted "$BLOCK_DEV" -- mkpart primary 512MiB -${SWAP_SIZE_IN_GB}GiB
    NIXOS_PARTITION="${BLOCK_DEV}${PARTITION_PREFIX}1"

    $RUN parted "$BLOCK_DEV" -- mkpart primary linux-swap -${SWAP_SIZE_IN_GB}GiB 100%
    SWAP_PARTITION="${BLOCK_DEV}${PARTITION_PREFIX}2"

    $RUN parted "$BLOCK_DEV" -- mkpart ESP fat32 1MiB 512MiB
    $RUN parted "$BLOCK_DEV" -- set 3 boot on
    BOOT_PARTITION="${BLOCK_DEV}${PARTITION_PREFIX}3"

    #
    # 2.2.3. Formatting
    #

    echo "Formatting partitions..."

    $RUN mkfs.ext4 -L nixos "$NIXOS_PARTITION"
    $RUN mkswap -L swap "$SWAP_PARTITION"
    $RUN mkfs.fat -F 32 -n boot "$BOOT_PARTITION"

    #
    # 2.3. Installing
    #

    echo "Mounting filesystems..."

    $RUN mount "$NIXOS_PARTITION" /mnt

    $RUN mkdir -p /mnt/boot
    $RUN mount "$BOOT_PARTITION" /mnt/boot

    echo "Generating default NixOS configuration..."
    $RUN nixos-generate-config --root /mnt

    echo "Applying NixOS configuration from $NIXOS_CONFIGURATION_URL..."
    $RUN curl -o /mnt/etc/nixos/configuration.nix $NIXOS_CONFIGURATION_URL

    echo "Starting the NixOS install..."
    $RUN nixos-install
else
    echo "Usage: $0 /dev/<BLOCK_DEV> [--dry-run]"
fi
