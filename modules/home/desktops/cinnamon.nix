# The user half of Cinnamon: settings that would otherwise be clicked through
# System Settings and live only in this machine's dconf database. The system
# half is in modules/nixos/desktops/cinnamon.nix.
{ config, lib, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf (cfg.roles.desktop && cfg.desktopEnvironment == "cinnamon") {
    # System Settings -> Font Selection -> Text scaling factor.
    #
    # Cinnamon hands 96 * this to X clients as Xft.dpi. On nokron's 27" 4K
    # panels (~163 DPI), 1.5 lands close to the real density. Chrome and
    # Electron apps scale their whole UI from Xft.dpi on X11, and GTK scales
    # its text. Alacritty reads it too, which is why nokron's terminal font size
    # in hosts/nokron/default.nix is chosen with this factor applied.
    dconf.settings."org/cinnamon/desktop/interface".text-scaling-factor = 1.5;

    # System Settings -> Sound -> Sounds.
    dconf.settings."org/cinnamon/sounds" = {
      notification-enabled = false;
      tile-enabled = false;
      switch-enabled = false;
    };
  };
}
