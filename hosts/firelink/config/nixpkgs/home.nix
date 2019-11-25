{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Marshall Bowers";
    userEmail = "elliott.codes@gmail.com";
  };
}
