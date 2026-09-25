# The user half of the gaming role. The system half -- the Steam module and
# 32-bit graphics support -- is in modules/nixos/gaming.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.gaming {
    home.packages = with pkgs; [
      lutris
      runelite
      wine
    ];
  };
}
