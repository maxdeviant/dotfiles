{ config, lib, pkgs, inputs, ... }:

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

      inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.claude-code

      # Rust
      rustup
      gcc

      # Python
      python3
    ];
  };
}
