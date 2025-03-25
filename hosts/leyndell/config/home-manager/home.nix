{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "maxdeviant";
  home.homeDirectory = "/Users/maxdeviant";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

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

      source "$HOME/.cargo/env.fish"

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
    userEmail = "git@maxdeviant.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Marshall Bowers";
        email = "git@maxdeviant.com";
      };
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    ripgrep
    bat
    cloc
    tree
    graphviz
    htop
    jq
    just
    watchexec

    # Build dependencies
    cmake

    # Kubernetes
    doctl
    kubectl

    # Gleam
    gleam
    erlang_28
    rebar3

    # Node.js
    volta

    # Nickel
    nickel
    nls

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/maxdeviant/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
