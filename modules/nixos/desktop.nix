# The system half of the desktop role: X, the display manager, and fonts. The
# desktop environment itself comes from modules/nixos/desktops/, picked by
# maxdeviant.desktopEnvironment. The user half -- terminal, browser, screenshot
# tooling -- lives in modules/home/terminal.nix and modules/home/desktop.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.desktop {
    services.xserver.enable = true;
    services.xserver.xkb.layout = "us";

    services.xserver.displayManager.lightdm.enable = true;

    assertions = [
      {
        assertion = cfg.desktopEnvironment != null;
        message = "maxdeviant.roles.desktop requires maxdeviant.desktopEnvironment to be set.";
      }
    ];

    # Needed system-wide rather than per-user so that the display manager and
    # other pre-login surfaces can render in it.
    fonts.packages = [ pkgs.fira-code ];
  };
}
