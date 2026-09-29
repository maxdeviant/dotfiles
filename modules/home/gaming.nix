# The user half of the gaming role. The system half -- the Steam module and
# 32-bit graphics support -- is in modules/nixos/gaming.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.gaming {
    home.packages = with pkgs; [
      # Upstream only supports the Flatpak and nags about any other packaging;
      # the nixpkgs FHS wrapper works fine, so turn the nag off. Battle.net
      # runs in here; the manual setup is in docs/battle-net.md.
      (bottles.override { removeWarningPopup = true; })
      lutris
      runelite
      wine
    ];

    # An in-game overlay for frame rate, frame times, and GPU/CPU stats. It
    # only hooks games launched through it, so nothing shows by default: add
    # `mangohud %command%` to a game's Steam launch options. Right Shift+F12
    # toggles the overlay once it's running.
    programs.mangohud = {
      enable = true;
      settings = {
        # A frame time graph shows stutter that an FPS average hides.
        fps = true;
        frametime = true;
        frame_timing = true;

        # Clock and power next to load, since load alone can't tell a busy
        # GPU from one idling at a low clock.
        gpu_stats = true;
        gpu_core_clock = true;
        gpu_power = true;
        gpu_temp = true;
        vram = true;
        gpu_name = true;

        cpu_stats = true;
        cpu_mhz = true;
        cpu_temp = true;
        ram = true;

        # Which translation layer (DXVK, VKD3D-Proton, or native) the game is
        # on, and at what resolution.
        engine_version = true;
        vulkan_driver = true;
        resolution = true;
      };
    };
  };
}
