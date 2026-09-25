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

      # For exporting the Zed settings from common/config/zed/.
      nickel
    ];
  };
}
