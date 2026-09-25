# The user half of the desktop role. The system half -- X, lightdm, Cinnamon,
# fonts -- is in modules/nixos/desktop.nix.
{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.desktop {
    home.packages = with pkgs; [
      google-chrome

      feh
      maim
      xclip
    ];
  };
}
