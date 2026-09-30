# The official Jagex Launcher, from its Linux beta.
#
# Jagex only ships an AppImage, which can't run on NixOS as-is, so this wraps
# it in an FHS environment. The launcher would normally update itself in place,
# but that only kicks in when it runs as a real AppImage, so updates happen by
# bumping `version` and `hash` here instead. Both come from the update feed:
#
#   https://rs-launcher-updates.runescape.com/production/latest-linux.yml
#
# The `sha512` in there is already base64, so it goes straight into the hash.
{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "jagex-launcher";
  version = "0.1.7";

  src = fetchurl {
    url = "https://rs-launcher-updates.runescape.com/production/linux/x64/releases/${version}/jagex-launcher-beta-linux-x86_64.AppImage";
    hash = "sha512-IdoYQYeaLYOzMTWOON9AWHTKFuhYKqYCqxg1bW93BoGbE4cNaFgaA/l5499w/0/Zg52JhN/EgdetM4aZ96oJvw==";
  };

  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Inside the FHS sandbox, /etc/localtime is a link to /.host-etc/localtime.
  # Java names the time zone after the `zoneinfo/` part of that link's target,
  # and when there isn't one it falls back to GMT, so RuneLite's timers
  # (farming patches, birdhouses, and so on) all show UTC. Following the link
  # all the way down does end in `zoneinfo/<zone>`, so hand Java that as TZ.
  profile = ''
    if [ -z "''${TZ:-}" ]; then
      zone=$(readlink -f /etc/localtime)
      case "$zone" in
        */zoneinfo/*) export TZ="''${zone#*/zoneinfo/}" ;;
      esac
      unset zone
    fi
  '';

  # The desktop entry also registers the launcher as the `rshub://` handler,
  # which the login flow redirects back through.
  extraInstallCommands = ''
    install -Dm444 ${contents}/jagex-launcher.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/jagex-launcher.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    install -Dm444 ${contents}/usr/share/icons/hicolor/512x512/apps/jagex-launcher.png \
      -t $out/share/icons/hicolor/512x512/apps
  '';

  meta = {
    description = "Official launcher for RuneScape and Old School RuneScape";
    homepage = "https://www.jagex.com/";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "jagex-launcher";
  };
}
