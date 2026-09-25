{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  home.username = cfg.identity.username;

  # mkDefault so a host can override, and platform-aware so this module works
  # unchanged if it is ever imported by a standalone Home Manager config.
  home.homeDirectory = lib.mkDefault (
    if pkgs.stdenv.hostPlatform.isDarwin then
      "/Users/${cfg.identity.username}"
    else
      "/home/${cfg.identity.username}"
  );

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
