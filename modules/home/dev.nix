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

    # Loads a project's environment (e.g., its `nix develop` shell) on `cd`.
    # Hooks into fish and bash automatically, since both are enabled in
    # modules/home/shell.nix. nix-direnv caches the flake shell and keeps it
    # from being garbage collected.
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
