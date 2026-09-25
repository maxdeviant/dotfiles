# Option schema shared by the NixOS and Home Manager evaluations.
#
# Declarations only -- deliberately no `config` block. This module is imported
# into *both* evaluations: into NixOS directly from `flake.nix`, and into Home
# Manager via `home-manager.sharedModules` in `modules/nixos/home-manager.nix`,
# which also mirrors the evaluated values across the boundary.
#
# The upshot is that a home module reads `config.maxdeviant.*` exactly the way a
# system module does. That is what keeps the home modules portable to the macOS
# hosts later, where there is no NixOS evaluation to reach into: there you set
# these values directly instead of mirroring them.
{ lib, ... }:

{
  options.maxdeviant = {
    identity = {
      username = lib.mkOption {
        type = lib.types.str;
        default = "maxdeviant";
        description = "Login name of the primary user.";
      };

      fullName = lib.mkOption {
        type = lib.types.str;
        default = "Marshall Bowers";
        description = "Full name, used for commit authorship.";
      };

      email = lib.mkOption {
        type = lib.types.str;
        default = "git@maxdeviant.com";
        description = "Email address, used for commit authorship.";
      };
    };

    theme = {
      font = {
        monospace = lib.mkOption {
          type = lib.types.str;
          # Not "Fira Code Retina": nixpkgs' fira-code ships only the variable
          # font, which has no Retina family, so fontconfig would fall back to
          # a proportional font.
          default = "Fira Code";
          description = "Monospace font family, used by the terminal.";
        };

        size = lib.mkOption {
          type = lib.types.int;
          default = 16;
          description = "Monospace font size, in points.";
        };
      };

      colors = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        description = "Terminal color palette, keyed by ANSI color name.";
        default = {
          background = "#1d1f28";
          foreground = "#fdfdfd";
          cursor = "#c574dd";

          black = "#282a36";
          red = "#f37f97";
          green = "#5adecd";
          yellow = "#f2a272";
          blue = "#8897f4";
          magenta = "#c574dd";
          cyan = "#79e6f3";
          white = "#fdfdfd";

          brightBlack = "#414458";
          brightRed = "#ff4971";
          brightGreen = "#18e3c8";
          brightYellow = "#ff8037";
          brightBlue = "#556fff";
          brightMagenta = "#b043d1";
          brightCyan = "#3fdcee";
          brightWhite = "#bebec1";
        };
      };
    };

    roles = {
      desktop = lib.mkEnableOption "the graphical desktop";
      dev = lib.mkEnableOption "development tooling";
      gaming = lib.mkEnableOption "games and their runtimes";
    };
  };
}
