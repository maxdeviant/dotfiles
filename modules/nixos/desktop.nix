# The system half of the desktop role: X, the display manager, the session, and
# fonts. The user half -- terminal, browser, screenshot tooling -- lives in
# modules/home/terminal.nix and modules/home/desktop.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.desktop {
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";

    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    # Note the path: this moved out from under services.xserver. The old
    # spelling still resolves through a renamed-option alias, but warns.
    services.displayManager.defaultSession = "cinnamon";

    # Needed system-wide rather than per-user so that the display manager and
    # other pre-login surfaces can render in it.
    fonts.packages = [ pkgs.fira-code ];
  };
}
