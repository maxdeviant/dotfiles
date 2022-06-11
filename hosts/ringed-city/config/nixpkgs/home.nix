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
    shellAliases = {
      gs = "git status";
      gc = "git commit";
      gca = "git add -A; and git commit";
      gd = "git diff";
      gl = "git log";
      gp = "git pull";
      goops = "git add -A; and git reset --hard HEAD";
    };
    shellInit = ''
      set -p fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish-foreign-env/functions
      fenv source ${config.home.profileDirectory}/etc/profile.d/nix.sh > /dev/null
      set -e fish_function_path[1]

      set -gx VOLTA_HOME "$HOME/.volta"
      set -gx PATH $PATH "$VOLTA_HOME/bin"

      set -gx PATH $PATH "$HOME/.cargo/bin"

      function gll
        git log --graph --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end

      function glll
        git log --graph --stat --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end
    '';
  };

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal.family = "Fire Code Retina";
        size = 16;
      };

      draw_bold_text_with_bright_colors = true;

      colors = {
        primary = {
          background = "#1d1f28";
          foreground = "#fdfdfd";
        };

        cursor = {
          text = "#c574dd";
          cursor = "#c574dd";
        };

        normal = {
          black = "#282a36";
          red = "#f37f97";
          green = "#5adecd";
          yellow = "#f2a272";
          blue = "#8897f4";
          magenta = "#c574dd";
          cyan = "#79e6f3";
          white = "#fdfdfd";
        };

        bright = {
          black = "#414458";
          red = "#ff4971";
          green = "#18e3c8";
          yellow = "#ff8037";
          blue = "#556fff";
          magenta = "#b043d1";
          cyan = "#3fdcee";
          white = "#bebec1";
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = false;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
      username = {
        show_always = true;
      };
      hostname = {
        ssh_only = false;
      };
      directory = {
        truncation_length = 1;
        truncate_to_repo = false;
        fish_style_pwd_dir_length = 1;
      };
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = ''
      set -g mouse on
    '';
  };

  programs.git = {
    enable = true;
    userName = "Marshall Bowers";
    userEmail = "elliott.codes@gmail.com";
    extraConfig = {
      pull.rebase = false;
    };
  };

  home.packages = with pkgs; [
    python3

    ripgrep
    bat
    htop

    # WorkOS
    doppler
  ];
}
