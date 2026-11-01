# WowUp-CF, the build of WowUp that can install addons from CurseForge.
#
# Upstream only ships an AppImage, which can't run on NixOS as-is, so this wraps
# it in an FHS environment. The app would normally update itself in place, but
# that only kicks in when it runs as a real AppImage, so updates happen by
# bumping `version` and `hash` here instead. Both come from the update feed:
#
#   https://github.com/WowUp/WowUp.CF/releases/latest/download/latest-linux.yml
#
# The `sha512` in there is already base64, so it goes straight into the hash.
{
  lib,
  appimageTools,
  asar,
  fetchurl,
}:

let
  pname = "wowup-cf";
  version = "2.24.1";

  src = fetchurl {
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v${version}/WowUp-CF-${version}.AppImage";
    hash = "sha512-uc5Y7BZUF96nwD1ckoe2O3iVJ5Y1flq4Sgc3ED4pRqXzgMDp16LhtIaj5mzdalaTHxbEOBC+Wv/C+Rlxo8fOtQ==";
  };

  # The ad panel is shown whenever an enabled provider has `adRequired` set, so
  # turning it off for CurseForge removes the panel altogether. The code is
  # minified and this match is on its exact text, so an update that changes it
  # fails the build instead of quietly bringing the ads back.
  #
  # Electron loads `resources/app` when there's no `app.asar`, which saves
  # having to work out what to unpack again when repacking the archive.
  contents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      ${lib.getExe asar} extract $out/resources/app.asar $out/resources/app
      rm -r $out/resources/app.asar $out/resources/app.asar.unpacked

      substituteInPlace $out/resources/app/dist/main.*.js \
        --replace-fail \
          'this.allowEdit=!0,this.adRequired=!0,this.enabled=!0' \
          'this.allowEdit=!0,this.adRequired=!1,this.enabled=!0'
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = contents;

  extraInstallCommands = ''
    install -Dm444 ${contents}/wowup-cf.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/wowup-cf.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
    install -Dm444 ${contents}/usr/share/icons/hicolor/512x512/apps/wowup-cf.png \
      -t $out/share/icons/hicolor/512x512/apps
  '';

  meta = {
    description = "World of Warcraft addon manager with CurseForge support, without the ad panel";
    homepage = "https://wowup.io/";
    # WowUp itself is GPL-3.0, but this runs on Overwolf's closed-source Electron.
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "wowup-cf";
  };
}
