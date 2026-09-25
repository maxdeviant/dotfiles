#!/usr/bin/env bash
#
# Automates the partitioning, formatting, and mounting steps from the NixOS
# manual ("Installation" -> "Manual Installation") for a single-disk UEFI system.
#
# Layout:
#   1: ESP  (FAT32, label "boot")  -> /boot
#   2: root (ext4,  label "nixos") -> /
#   3: swap (label "swap")         -> optional, at the end of the disk

set -euo pipefail

SWAP_SIZE_IN_GB=8
ESP_SIZE_IN_MB=1024
CONFIG_URL=''
DRY_RUN=0
ASSUME_YES=0
BLOCK_DEV=''

usage() {
    cat <<EOF
Usage: $0 /dev/<BLOCK_DEV> [options]

Options:
  --swap-size <GiB>  Size of the swap partition (default: $SWAP_SIZE_IN_GB, 0 to disable)
  --config <url>     Download configuration.nix from <url> instead of using the generated one
  --dry-run          Print the commands that would be run without running them
  --yes              Skip the confirmation prompt
EOF
}

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        echo "+ $*"
    else
        "$@"
    fi
}

# NVMe and MMC devices (e.g., /dev/nvme0n1, /dev/mmcblk0) use a "p" separator
# before the partition number.
partition() {
    if [[ "$BLOCK_DEV" =~ [0-9]$ ]]; then
        echo "${BLOCK_DEV}p$1"
    else
        echo "${BLOCK_DEV}$1"
    fi
}

while [ $# -gt 0 ]; do
    case "$1" in
        --swap-size) SWAP_SIZE_IN_GB="$2"; shift 2 ;;
        --config) CONFIG_URL="$2"; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        --yes) ASSUME_YES=1; shift ;;
        -h|--help) usage; exit 0 ;;
        -*) echo "Unknown option: $1"; usage; exit 1 ;;
        *) BLOCK_DEV="$1"; shift ;;
    esac
done

if [ -z "$BLOCK_DEV" ] || [ ! -b "$BLOCK_DEV" ]; then
    usage
    exit 1
fi

if [ "$EUID" -ne 0 ] && [ "$DRY_RUN" -eq 0 ]; then
    echo "Please run as root."
    exit 1
fi

if lsblk -nro MOUNTPOINTS "$BLOCK_DEV" | grep -q .; then
    echo "$BLOCK_DEV (or one of its partitions) is mounted or in use as swap:"
    lsblk -o NAME,SIZE,FSTYPE,LABEL,MOUNTPOINTS "$BLOCK_DEV"
    echo "Unmount it (umount -R /mnt; swapoff -a) and try again."
    exit 1
fi

ESP_PARTITION=$(partition 1)
ROOT_PARTITION=$(partition 2)
SWAP_PARTITION=$(partition 3)

if [ "$SWAP_SIZE_IN_GB" -gt 0 ]; then
    ROOT_END="-${SWAP_SIZE_IN_GB}GiB"
else
    ROOT_END="100%"
fi

[ "$DRY_RUN" -eq 1 ] && echo "Performing a dry run!"

echo "Preparing to install NixOS on $BLOCK_DEV:"
echo
lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MODEL "$BLOCK_DEV"
echo

if [ "$ASSUME_YES" -eq 0 ] && [ "$DRY_RUN" -eq 0 ]; then
    read -r -p "This will ERASE ALL DATA on $BLOCK_DEV. Type 'yes' to continue: " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "Aborting."
        exit 1
    fi
fi

#
# Partitioning (UEFI/GPT)
#

echo "Wiping existing signatures..."
run wipefs -a "$BLOCK_DEV"

echo "Partitioning drive..."
run parted -s -a optimal "$BLOCK_DEV" -- mklabel gpt
run parted -s -a optimal "$BLOCK_DEV" -- mkpart ESP fat32 1MiB "${ESP_SIZE_IN_MB}MiB"
run parted -s "$BLOCK_DEV" -- set 1 esp on
run parted -s -a optimal "$BLOCK_DEV" -- mkpart root ext4 "${ESP_SIZE_IN_MB}MiB" "$ROOT_END"
if [ "$SWAP_SIZE_IN_GB" -gt 0 ]; then
    run parted -s -a optimal "$BLOCK_DEV" -- mkpart swap linux-swap "-${SWAP_SIZE_IN_GB}GiB" 100%
fi

# Make sure the kernel/udev have picked up the new partitions before we format them.
run partprobe "$BLOCK_DEV"
run udevadm settle

#
# Formatting
#

echo "Formatting partitions..."
run mkfs.fat -F 32 -n boot "$ESP_PARTITION"
run mkfs.ext4 -F -L nixos "$ROOT_PARTITION"
if [ "$SWAP_SIZE_IN_GB" -gt 0 ]; then
    run mkswap -f -L swap "$SWAP_PARTITION"
fi

#
# Installing
#

echo "Mounting filesystems..."
run mount "$ROOT_PARTITION" /mnt
run mkdir -p /mnt/boot
# umask=077 keeps the ESP (and the systemd-boot random seed) from being world-readable.
run mount -o umask=077 "$ESP_PARTITION" /mnt/boot
if [ "$SWAP_SIZE_IN_GB" -gt 0 ]; then
    # Swap needs to be active so nixos-generate-config adds it to `swapDevices`.
    run swapon "$SWAP_PARTITION"
fi

echo "Generating default NixOS configuration..."
run nixos-generate-config --root /mnt

if [ -n "$CONFIG_URL" ]; then
    echo "Applying NixOS configuration from $CONFIG_URL..."
    run cp /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.generated.nix
    run curl -fsSL -o /mnt/etc/nixos/configuration.nix "$CONFIG_URL"
fi

if [ "$DRY_RUN" -eq 0 ]; then
    echo
    echo "Review /mnt/etc/nixos/hardware-configuration.nix and configuration.nix before installing."
    read -r -p "Open configuration.nix in ${EDITOR:-vim} now? [Y/n] " EDIT
    if [[ ! "$EDIT" =~ ^[Nn] ]]; then
        "${EDITOR:-vim}" /mnt/etc/nixos/configuration.nix
    fi
fi

echo "Starting the NixOS install..."
run nixos-install

echo
echo "Done! Before rebooting, set a password for your user (if you defined one):"
echo "  nixos-enter --root /mnt -c 'passwd <user>'"
