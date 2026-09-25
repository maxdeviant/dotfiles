# The user half of the gaming role. The system half -- the Steam module and
# 32-bit graphics support -- is in modules/nixos/gaming.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.gaming {
    home.packages = with pkgs; [
      # Upstream only supports the Flatpak and nags about any other packaging;
      # the nixpkgs FHS wrapper works fine, so turn the nag off. Battle.net
      # runs in here; the manual setup is in docs/battle-net.md.
      (bottles.override { removeWarningPopup = true; })
      lutris
      runelite
      wine
    ];
  };
}
