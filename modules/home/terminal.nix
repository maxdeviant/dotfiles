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
      };
    };
  };
}
