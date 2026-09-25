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

  home-manager.users.${config.maxdeviant.identity.username}.imports = [ ./home.nix ];

  # The first version of NixOS installed on this machine. This is not a "which
  # nixpkgs" knob -- it stays at 26.05 even though the flake tracks unstable.
  # See the notes in the NixOS manual before ever changing it.
  system.stateVersion = "26.05";
}
