# Home configuration specific to nokron. Anything portable belongs in
# modules/home/ instead, so the other hosts can pick it up later.
{ config, ... }:

let
  # mkOutOfStoreSymlink needs the path to the live checkout: a relative path
  # would resolve to the flake's copy in the store, which is read-only.
  dotfiles = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";
in
{
  home.packages = [ ];

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
}
