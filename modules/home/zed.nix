{ config, lib, pkgs, ... }:

let
  cfg = config.maxdeviant;
in
{
  # Zed's settings.json and keymap.json are linked per-host, since they're
  # exported from the shared Nickel sources with host-specific overrides. See
  # hosts/nokron/home.nix.
  config = lib.mkIf cfg.roles.dev {
    home.packages = with pkgs; [
      zed-editor

      # nixpkgs names the CLI `zeditor`, to avoid clashing with an older `zed`.
      # A real binary rather than a shell alias, so it also works in scripts
      # and as $EDITOR.
      (runCommand "zed-alias" { } ''
        mkdir -p $out/bin
        ln -s ${zed-editor}/bin/zeditor $out/bin/zed
      '')

      # For exporting the Zed settings from common/config/zed/.
      nickel
    ];
  };
}
