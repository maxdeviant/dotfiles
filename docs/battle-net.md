# Battle.net on NixOS

Battle.net runs through [Bottles](https://usebottles.com/), which is installed by the gaming role (see [`modules/home/gaming.nix`](../modules/home/gaming.nix)). Everything below is manual, one-time setup that lives in the bottle rather than in this repo.

> Previously this was done through Lutris. Lutris treats the launcher as "the game" and ties its lifetime to its own run/stop state, which made it awkward to just leave Battle.net open. Bottles runs it as an ordinary long-lived program.

## Setup

1. Open Bottles and let it finish downloading its default runner and components on first launch.
2. Create a new bottle:
   - **Name:** `Battle.net`
   - **Environment:** Gaming
3. Open the bottle, go to **Installers**, and install **Battle.net**. This pulls in the fonts and dependencies the launcher needs.
4. Log in to Battle.net, then open **Settings → App** and set:
   - **When I close Battle.net:** Exit completely
   - **When I launch a game:** Keep Battle.net open
5. _(Optional)_ In the bottle's program list, use **Add to Desktop Entries** to get Battle.net in the Cinnamon menu.

The bottle lives in `~/.local/share/bottles/bottles/Battle.net`. That directory is the thing to back up if you want to avoid reinstalling games.

## Why the close setting matters

By default, closing Battle.net minimizes it to the system tray. Under Wine the tray icon frequently doesn't show up, so the launcher looks like it quit while it's actually still running in the background. Setting it to exit completely avoids the phantom process.

## Troubleshooting

- **Launcher window is blank or black:** in the bottle's settings, switch the runner to the newest `soda` or `ge-proton`. If that doesn't fix it, turn off hardware acceleration in Battle.net's settings.
- **Launcher insists on updating before it will log in:** this is normal; let it update and restart itself.
