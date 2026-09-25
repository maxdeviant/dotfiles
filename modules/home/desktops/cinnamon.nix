# The user half of Cinnamon: settings that would otherwise be clicked through
# System Settings and live only in this machine's dconf database. The system
# half is in modules/nixos/desktops/cinnamon.nix.
{ config, lib, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf (cfg.roles.desktop && cfg.desktopEnvironment == "cinnamon") {
    # System Settings -> Sound -> Sounds.
    dconf.settings."org/cinnamon/sounds" = {
      notification-enabled = false;
      tile-enabled = false;
      switch-enabled = false;
    };
  };
}
