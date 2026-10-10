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

    # Wine/Proton (GE-Proton 10+) uses /dev/ntsync for Windows synchronization
    # primitives when it exists, instead of emulating them with fsync/esync.
    # The kernel ships the driver as a module but nothing autoloads it.
    boot.kernelModules = [ "ntsync" ];
  };
}
