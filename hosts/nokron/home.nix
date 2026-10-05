# Home configuration specific to nokron. Anything portable belongs in
# modules/home/ instead, so the other hosts can pick it up later.
{ config, pkgs, ... }:

let
  # mkOutOfStoreSymlink needs the path to the live checkout: a relative path
  # would resolve to the flake's copy in the store, which is read-only.
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = with pkgs; [
    amdgpu_top
    aseprite
    ldtk
  ];

  # btop only reads AMD GPUs through rocm-smi, which nixpkgs leaves out unless
  # asked. The GPU boxes are hidden by default; gpu0 is the 9070 XT.
  programs.btop = {
    package = pkgs.btop.override { rocmSupport = true; };
    settings.shown_boxes = "cpu mem net proc gpu0";
  };

  # Linked to the checkout rather than the store so that Zed can still write
  # to them. Regenerate after editing the Nickel sources:
  #
  #   nickel export --format json hosts/nokron/config/zed/settings.ncl > hosts/nokron/config/zed/settings.json
  #   nickel export --format json common/config/zed/keymap-linux.ncl > hosts/nokron/config/zed/keymap.json
  #
  # Changes Zed makes to the JSON are overwritten by the next export, so port
  # anything worth keeping back to the Nickel.
  xdg.configFile = {
    "zed/settings.json".source = link "hosts/nokron/config/zed/settings.json";
    "zed/keymap.json".source = link "hosts/nokron/config/zed/keymap.json";
  };

  # Also linked to the checkout, since Claude Code writes to it (e.g., `/model`
  # and `/config`). The `PostToolUse` hook records XP for Claude Code's edits
  # through the `code-stats-ls` from modules/home/zed.nix.
  home.file.".claude/settings.json".source = link "hosts/nokron/config/claude/settings.json";
}
