# RuneLite on NixOS

I don't want to forget how to do this, so just jotting it down here.

If you want to customize the launch options when running RuneLite through the Jagex Launcher, do the following.

I have the Jagex Launcher installed through Lutris.

Inside of the RuneLite directory my current state looks like this:

```
λ ls -l ~/Games/jagex-launcher/drive_c/Program\ Files\ \(x86\)/Jagex\ Launcher/Games/RuneLite/
total 45180
-rwxr--r-- 1 maxdeviant users 46253248 Aug  9  2023 RuneLite.AppImage
lrwxrwxrwx 1 maxdeviant users      107 Aug  9  2023 RuneLite.exe -> '/home/maxdeviant/Games/jagex-launcher/drive_c/Program Files (x86)/Jagex Launcher/Games/RuneLite/runelite.sh'
-rwxr--r-- 1 maxdeviant users       91 Aug  9  2023 runelite.sh
```

`RuneLite.exe` is symlinked to `runelite.sh` which has the following contents:

```sh
#!/bin/sh
GDK_SCALE=2 "$(pwd)"/Games/RuneLite/RuneLite.AppImage --appimage-extract-and-run
```

`GDK_SCALE=2` is used to size up the RuneLite client, since it's too small on my 4K monitor otherwise.

You can also set `_JAVA_AWT_WM_NONREPARENTING=1` here if using a tiling WM.
