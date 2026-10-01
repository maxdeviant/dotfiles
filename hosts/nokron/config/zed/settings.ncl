# nokron's Zed settings: the shared settings, plus the overrides this host
# needs. `force` is required to replace a value the shared file already sets.
(import "../../../../common/config/zed/settings.ncl")
& {
  # "Fira Code Retina" doesn't exist on NixOS; see modules/options.nix.
  buffer_font_family | force = "Fira Code",

  # Zed's default "system" shell comes from $SHELL in the environment Zed was
  # launched from, which isn't always fish, so pin it.
  terminal = {
    shell = {
      program = "fish",
    },
  },

  auto_install_extensions = {
    # Its language server comes from pkgs/code-stats-ls.nix.
    code-stats = true,
  },
}
