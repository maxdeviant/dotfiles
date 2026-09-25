{ config, lib, ... }:

let
  cfg = config.maxdeviant;
  inherit (cfg.theme) colors;
in
{
  config = lib.mkIf cfg.roles.desktop {
    programs.alacritty = {
      enable = true;

      settings = {
        font = {
          normal.family = cfg.theme.font.monospace;
          size = cfg.theme.font.size;
        };

        colors = {
          draw_bold_text_with_bright_colors = true;

          primary = {
            inherit (colors) background foreground;
          };

          cursor = {
            text = colors.cursor;
            cursor = colors.cursor;
          };

          normal = {
            inherit (colors)
              black
              red
              green
              yellow
              blue
              magenta
              cyan
              white
              ;
          };

          bright = {
            black = colors.brightBlack;
            red = colors.brightRed;
            green = colors.brightGreen;
            yellow = colors.brightYellow;
            blue = colors.brightBlue;
            magenta = colors.brightMagenta;
            cyan = colors.brightCyan;
            white = colors.brightWhite;
          };
        };

        keyboard.bindings = [
          # Send ESC+CR so that programs reading the terminal can tell
          # Shift+Return apart from a bare Return.
          {
            key = "Return";
            mods = "Shift";
            # Nix strings have no \u escape -- "\u001B" would collapse to the
            # literal text "u001B" -- so the escape character comes from JSON.
            chars = builtins.fromJSON ''"\u001B\r"'';
          }
        ];
      };
    };
  };
}
