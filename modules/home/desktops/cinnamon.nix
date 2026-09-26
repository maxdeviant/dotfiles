# The user half of Cinnamon: settings that would otherwise be clicked through
# System Settings and live only in this machine's dconf database. The system
# half is in modules/nixos/desktops/cinnamon.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;

  # Cinnamon formats this with GLib, not strftime. `%-d` avoids the padding
  # space `%e` adds on single-digit days; `%P` is a lowercase am/pm.
  # Renders as e.g. "Fri Sep 25 06:44pm".
  clockFormat = "%a %b %-d %I:%M%P";

  # Applet settings aren't in dconf: each applet instance has a JSON file that
  # Cinnamon owns, carrying the settings schema alongside the values and
  # rewriting it when the applet is upgraded. A read-only store symlink would
  # break that, so patch the values in place instead. The glob covers whatever
  # instance ID the applet has; on a fresh install the file doesn't exist until
  # Cinnamon's first login, so it takes a second switch to apply.
  patchAppletSettings = uuid: jqArgs: filter: ''
    for file in "${config.xdg.configHome}"/cinnamon/spices/${uuid}/*.json; do
      [ -e "$file" ] || continue
      patched=$(mktemp)
      ${lib.getExe pkgs.jq} --indent 4 ${jqArgs} ${lib.escapeShellArg filter} \
        "$file" > "$patched"
      if ! cmp -s "$patched" "$file"; then
        run cp "$patched" "$file"
      fi
      rm "$patched"
    done
  '';
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

    # System Settings -> Keyboard -> Shortcuts -> System -> Screenshots and
    # Recording -> Copy a screenshot of an area to clipboard.
    #
    # Adds Super+Shift+S, carried over from firelink's sxhkd setup, alongside
    # the default. dconf replaces the whole list, so the default is restated.
    dconf.settings."org/cinnamon/desktop/keybindings/media-keys".area-screenshot-clip = [
      "<Control><Shift>Print"
      "<Super><Shift>s"
    ];

    # Panel clock -> Configure -> Use a custom date format.
    home.activation.cinnamonClockFormat = lib.hm.dag.entryAfter [ "writeBoundary" ]
      (patchAppletSettings "calendar@cinnamon.org"
        "--arg format ${lib.escapeShellArg clockFormat}"
        ''."use-custom-format".value = true | ."custom-format".value = $format'');

    # Panel sound -> Configure -> Show menu.
    #
    # Defaults to Super+Shift+S, which collides with the screenshot binding
    # above; whichever Cinnamon registers last wins. Unbind it.
    home.activation.cinnamonSoundMenuKey = lib.hm.dag.entryAfter [ "writeBoundary" ]
      (patchAppletSettings "sound@cinnamon.org" "" ''.keyOpen.value = ""'');
  };
}
