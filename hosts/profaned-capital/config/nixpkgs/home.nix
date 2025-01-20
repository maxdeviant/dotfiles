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
  home.stateVersion = "22.05";

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
      set --prepend fish_function_path ${
        if pkgs ? fishPlugins && pkgs.fishPlugins ? foreign-env then
          "${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d"
        else
          "${pkgs.fish-foreign-env}/share/fish-foreign-env/functions"
      }

      # https://github.com/NixOS/nix/issues/1512#issuecomment-374436047
      if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fenv source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      end

      fenv source ${config.home.profileDirectory}/etc/profile.d/nix.sh > /dev/null
      set -e fish_function_path[1]

      set -gx PATH $PATH "$HOME/.cargo/bin"

      set -gx VOLTA_HOME "$HOME/.volta"
      set -gx PATH $PATH "$VOLTA_HOME/bin"

      function gll
        git log --graph --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end

      function glll
        git log --graph --stat --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end

      function gopr -a pr_number
        if not string match -rq "[0-9]+" $pr_number
          echo "PR number is required."
          return 1
        end

        git fetch origin pull/$pr_number/head:pr/$pr_number
        git checkout pr/$pr_number
      end
    '';
  };

  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal.family = "Fira Code Retina";
        size = 16;
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
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

  programs.git = {
    enable = true;
    userName = "Marshall Bowers";
    userEmail = "elliott.codes@gmail.com";
    extraConfig = {
      pull.rebase = false;
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Marshall Bowers";
        email = "elliott.codes@gmail.com";
      };
    };
  };

  home.packages = with pkgs; [
    ripgrep
    bat
    cloc
    tree
    graphviz
    htop
    jq
    just

    doctl
    kubectl

    # Gleam
    gleam
    erlang_26
    rebar3
  ];
}
