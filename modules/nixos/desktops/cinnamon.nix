# The system half of Cinnamon. The user half -- its dconf settings -- is in
# modules/home/desktops/cinnamon.nix.
{ config, lib, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf (cfg.roles.desktop && cfg.desktopEnvironment == "cinnamon") {
    services.xserver.desktopManager.cinnamon.enable = true;

    # Note the path: this moved out from under services.xserver. The old
    # spelling still resolves through a renamed-option alias, but warns.
    services.displayManager.defaultSession = "cinnamon";
  };
}
