# nokron -- AMD desktop tower running NixOS.
{ config, ... }:

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

  home-manager.users.${config.maxdeviant.identity.username}.imports = [ ./home.nix ];

  # The first version of NixOS installed on this machine. This is not a "which
  # nixpkgs" knob -- it stays at 26.05 even though the flake tracks unstable.
  # See the notes in the NixOS manual before ever changing it.
  system.stateVersion = "26.05";
}
