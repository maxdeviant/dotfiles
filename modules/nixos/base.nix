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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

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
