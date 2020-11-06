{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "maxdeviant";
  home.homeDirectory = "/Users/maxdeviant";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  programs.fish = {
    enable = true;
    shellInit = ''
      set -p fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions
          fenv source ${config.home.profileDirectory}/etc/profile.d/nix.sh > /dev/null
          set -e fish_function_path[1]
    '';
  };

  programs.git = {
    enable = true;
    userName = "Marshall Bowers";
    userEmail = "elliott.codes@gmail.com";
  };

  home.packages = with pkgs; [
    python3
  ];
}
