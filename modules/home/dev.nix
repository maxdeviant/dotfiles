{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.dev {
    home.packages = with pkgs; [
      bat
      cloc
      fastfetch
      graphviz
      htop
      jq
      just
      ripgrep
      tree
      watchexec
    ];
  };
}
