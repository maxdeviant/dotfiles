# Baseline system configuration applied to every host.
{ config, pkgs, inputs, ... }:

let
  cfg = config.maxdeviant;
in
{
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Flakes replace channels, but the legacy lookup paths still exist and will
  # happily resolve to something else entirely. Pin both the registry and
  # `<nixpkgs>` to the exact revision in flake.lock so that `nix shell
  # nixpkgs#foo`, `nix-shell -p foo`, and the system all agree.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  nix.channel.enable = false;

  # Old generations accumulate in two places, and each needs its own limit.
  # Every generation keeps its closure alive in the store, so collect the old
  # ones on a schedule...
  #
  # This uses nh rather than nix.gc, whose only option is an age cutoff:
  # `--delete-older-than 30d` after a month without a rebuild leaves just the
  # current generation, with nothing to roll back to. nh keeps the union of
  # "the last N" and "anything from the last 30 days" instead.
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 10 --keep-since 30d";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ...and every generation with a distinct kernel copies its kernel and initrd
  # into the 1G /boot partition, which linuxPackages_latest churns through
  # quickly. A full /boot makes `nixos-rebuild switch` fail outright, and since
  # entries are only pruned during a switch, it can't fix itself. Cap the menu
  # well before that. Older generations just drop off the boot menu; they stay
  # in the store until the GC above removes them.
  boot.loader.systemd-boot.configurationLimit = 10;

  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  users.users.${cfg.identity.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.fish;
  };

  # This has to be set here as well as in Home Manager. The NixOS side is what
  # registers fish in /etc/shells and makes it usable as a login shell; the Home
  # Manager side supplies the actual configuration.
  programs.fish.enable = true;

  # Kept deliberately short. Everything else belongs in home.packages -- this is
  # only for what root needs, or what has to work before Home Manager activates.
  environment.systemPackages = with pkgs; [
    git # nixos-rebuild --flake reads this repo as root, and needs git to do it
    vim # rescue editor
    wget
  ];
}
