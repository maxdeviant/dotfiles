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

  playerctl = lib.getExe pkgs.playerctl;
  alacritty = lib.getExe config.programs.alacritty.package;

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

    # System Settings -> General -> Disable compositing for full-screen windows.
    #
    # Off by default on X11, so Muffin copies every frame of a fullscreen game
    # and vsyncs it a second time on top of the game's own vsync. At 4K60 a
    # frame that lands a hair late then waits out an extra refresh, and Elden
    # Ring dipped under 60 on nokron with GPU headroom to spare.
    dconf.settings."org/cinnamon/muffin".unredirect-fullscreen-windows = true;

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

    # Media keys drive Spotify.
    #
    # Cinnamon's own bindings go to whichever player the sound applet has
    # selected, which can be a browser tab instead. Unbind them so the custom
    # bindings below, which name Spotify explicitly, get the keys.
    dconf.settings."org/cinnamon/desktop/keybindings/media-keys" = {
      play = [ ];
      next = [ ];
      previous = [ ];
    };

    # System Settings -> Keyboard -> Shortcuts -> Launchers -> Launch terminal.
    #
    # Ctrl+Alt+T opens GNOME Terminal; Alacritty gets its own binding below.
    dconf.settings."org/cinnamon/desktop/keybindings/media-keys".terminal = [ ];

    # System Settings -> Keyboard -> Shortcuts -> Custom Shortcuts.
    #
    # Cinnamon only picks up entries named in `custom-list`.
    dconf.settings."org/cinnamon/desktop/keybindings".custom-list = [
      "alacritty"
      "spotify-play-pause"
      "spotify-next"
      "spotify-previous"
    ];
    # Launched from a keybinding, the new window carries the keypress's
    # timestamp, so the "smart" focus-new-windows policy lets it take focus.
    # Launched other ways, it can open behind the focused window.
    dconf.settings."org/cinnamon/desktop/keybindings/custom-keybindings/alacritty" = {
      name = "Alacritty";
      command = alacritty;
      binding = [ "<Super>Return" ];
    };
    dconf.settings."org/cinnamon/desktop/keybindings/custom-keybindings/spotify-play-pause" = {
      name = "Spotify: Play/Pause";
      command = "${playerctl} --player=spotify play-pause";
      binding = [ "XF86AudioPlay" ];
    };
    dconf.settings."org/cinnamon/desktop/keybindings/custom-keybindings/spotify-next" = {
      name = "Spotify: Next";
      command = "${playerctl} --player=spotify next";
      binding = [ "XF86AudioNext" ];
    };
    dconf.settings."org/cinnamon/desktop/keybindings/custom-keybindings/spotify-previous" = {
      name = "Spotify: Previous";
      command = "${playerctl} --player=spotify previous";
      binding = [ "XF86AudioPrev" ];
    };

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
