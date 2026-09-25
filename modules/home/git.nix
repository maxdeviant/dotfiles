{ config, ... }:

let
  cfg = config.maxdeviant;
in
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = cfg.identity.fullName;
        email = cfg.identity.email;
      };
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = cfg.identity.fullName;
        email = cfg.identity.email;
      };
      aliases = {
        tug = [
          "bookmark"
          "move"
          "--from"
          "heads(::@- & bookmarks())"
          "--to"
          "@-"
        ];
      };
    };
  };
}
