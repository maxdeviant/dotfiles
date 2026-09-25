# The system half of the gaming role. Steam needs a system-level module for its
# FHS wrapper and firewall rules; the games themselves are user packages and
# live in modules/home/gaming.nix.
{ config, lib, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.gaming {
    programs.steam.enable = true;

    hardware.graphics.enable = true;
    hardware.graphics.enable32Bit = true;
  };
}
