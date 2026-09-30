# RuneLite on NixOS

RuneLite runs natively, launched from the official [Jagex Launcher](https://www.jagex.com/)'s Linux beta. Both are installed by the gaming role (see [`modules/home/gaming.nix`](../modules/home/gaming.nix)), and there's no manual setup beyond logging in.

> Previously this was the Windows Jagex Launcher running in Wine through Lutris, with RuneLite's `RuneLite.exe` swapped for a script that ran the Linux AppImage. The Windows RuneLite no longer starts under Wine, and the Linux launcher makes the whole thing unnecessary.

## How it fits together

- **The launcher** is packaged in [`pkgs/jagex-launcher.nix`](../pkgs/jagex-launcher.nix). Jagex only ships an AppImage, so it runs in an FHS wrapper. The package's desktop entry also handles `rshub://` links, which the login flow redirects back through.
- **RuneLite:** when you hit Play, the launcher runs `~/.local/share/Jagex Launcher/games/runelite/RuneLite.AppImage`, downloading it first if nothing is there. The download is RuneLite's generic Linux AppImage, which NixOS can't run. Home Manager puts a link to the nixpkgs `runelite` at that path instead, so the launcher never downloads anything and runs ours.
- **Logging in:** the launcher hands the session to RuneLite through the `JX_SESSION_ID`, `JX_CHARACTER_ID`, and `JX_DISPLAY_NAME` environment variables.

The `runelite` in the gaming role is wrapped to:

- Set `GDK_SCALE=2`, since the client is too small on a 4K monitor otherwise.
- Unset `APPIMAGE` and `APPDIR`. If RuneLite sees `APPIMAGE`, it assumes it is an AppImage and relaunches the client through whatever that points at. Any variables the launcher sets would leak through to RuneLite, so this guards against that.

You can also set `_JAVA_AWT_WM_NONREPARENTING=1` in that wrapper if using a tiling WM.

## Updating the launcher

The launcher can't update itself in place when installed this way. To update it, take the new `version` and `sha512` from [the update feed](https://rs-launcher-updates.runescape.com/production/latest-linux.yml) and put them in [`pkgs/jagex-launcher.nix`](../pkgs/jagex-launcher.nix). The feed's `sha512` is already base64, so it goes straight into the `sha512-...` hash.

## Troubleshooting

- **Play does nothing:** the launcher logs "Launched RuneLite" as soon as the process starts, even if it dies right away, so its own log (`~/.config/Jagex Launcher/logs/`) won't show the problem. Check `~/.runelite/logs/launcher.log` instead.
- **The launcher downloaded RuneLite anyway:** check that `~/.local/share/Jagex Launcher/games/runelite/RuneLite.AppImage` is still the Home Manager link. If it was replaced, delete it and switch again.
