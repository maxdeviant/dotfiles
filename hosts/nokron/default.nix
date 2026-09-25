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
    gaming = false;
  };

  home-manager.users.${config.maxdeviant.identity.username}.imports = [ ./home.nix ];

  # The first version of NixOS installed on this machine. This is not a "which
  # nixpkgs" knob -- it stays at 26.05 even though the flake tracks unstable.
  # See the notes in the NixOS manual before ever changing it.
  system.stateVersion = "26.05";
}
