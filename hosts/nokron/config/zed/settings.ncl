# nokron's Zed settings: the shared settings, plus the overrides this host
# needs. `force` is required to replace a value the shared file already sets.
(import "../../../../common/config/zed/settings.ncl")
& {
  # "Fira Code Retina" doesn't exist on NixOS; see modules/options.nix.
  buffer_font_family | force = "Fira Code",
}
