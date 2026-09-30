# nokron -- AMD desktop tower running NixOS.
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nokron";

  # Everything downstream of these toggles fans out to both halves of the
  # configuration: modules/nixos/<role>.nix for the system side, and
  # modules/home/<role>.nix for the user side.
  maxdeviant.roles = {
    desktop = true;
    dev = true;
    gaming = true;
  };

  maxdeviant.desktopEnvironment = "cinnamon";

  # Smaller than the shared default because Cinnamon's 1.5 text scaling factor
  # (see modules/home/desktops/cinnamon.nix) also enlarges the terminal.
  maxdeviant.theme.font.size = 14;

  # nokron has two AMD GPUs: the RX 9070 XT (PCI 07:00.0) that drives both
  # displays, and the Ryzen iGPU (0e:00.0). Left to itself, Chrome renders on
  # the 9070 XT but opens the iGPU's render node for GBM, so importing a
  # hardware-decoded video frame fails ("nullptr returned from gbm_bo_import")
  # and kills the GPU process. Three of those and Chrome falls back to software
  # rendering for the rest of the session. Pin GBM to the 9070 XT; by-path
  # rather than renderD128, since renderD numbering can shift between boots.
  nixpkgs.overlays = [
    (final: prev: {
      google-chrome = prev.google-chrome.override {
        commandLineArgs = "--render-node-override=/dev/dri/by-path/pci-0000:07:00.0-render";
      };
    })
  ];

  # Steam's web helper is Chromium too, and left alone it renders on the iGPU,
  # then copies every frame across to the 9070 XT for display (~20% of the
  # iGPU's time while a game was running). DRI_PRIME points Mesa at the 9070
  # XT instead, and games launched from Steam inherit it.
  programs.steam.package = pkgs.steam.override {
    extraEnv.DRI_PRIME = "pci-0000_07_00_0";
  };

  # The 9070 XT's display engine has hung here ("flip_done timed out"), which
  # takes the TTYs down with it since switching VTs needs a modeset on the same
  # hung pipe. NixOS only allows the sync SysRq by default; enable all of them
  # so Alt+SysRq+REISUB can still reboot cleanly.
  boot.kernel.sysctl."kernel.sysrq" = 1;

  # PipeWire comes from the Cinnamon defaults, but without RTKit its audio
  # thread never gets realtime priority, so under load it misses deadlines and
  # the output crackles (hundreds of xruns per stream in pw-top).
  security.rtkit.enable = true;

  # With RTKit available, PipeWire's client library (used in-process by the
  # ALSA plugin, e.g. RuneLite's Java audio) reads RTKit's RTTimeUSecMax as 0
  # and sets RLIMIT_RTTIME to 0, so the kernel SIGKILLs the whole app the
  # moment its RT audio thread is caught running. Keep RT on the daemons, where
  # it matters, and skip it in clients, which is how they ran before RTKit.
  services.pipewire.extraConfig.client."10-no-rt" = {
    "context.properties"."module.rt" = false;
  };

  # The graph runs at the smallest quantum any client asks for, and games under
  # Wine ask for 256 (~5ms). That's too tight here: those streams and RuneLite
  # racked up hundreds of xruns, and every xrun crackles on the shared sink, so
  # Chrome and Spotify crackled too. 1024 (~21ms) left the error counts flat.
  services.pipewire.extraConfig.pipewire."10-min-quantum" = {
    "context.properties"."default.clock.min-quantum" = 1024;
  };

  home-manager.users.${config.maxdeviant.identity.username}.imports = [ ./home.nix ];

  # The first version of NixOS installed on this machine. This is not a "which
  # nixpkgs" knob -- it stays at 26.05 even though the flake tracks unstable.
  # See the notes in the NixOS manual before ever changing it.
  system.stateVersion = "26.05";
}
