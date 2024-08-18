{ config, pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.nix
    arrterian.nix-env-selector
    esbenp.prettier-vscode
    justusadam.language-haskell
    rust-lang.rust-analyzer
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "night-owl";
      publisher = "sdras";
      version = "2.0.1";
      sha256 = "02a7dc555f46619f862e0bac5df8a3f73e16ceb53d7021e9dec7596f48ba1f31";
    }
    {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.5";
      sha256 = "ee8f2918cc3aea2cde133f483661b4f8e4f480ecac48eaf8cd4620a414bef9bd";
    }
    {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.25.4";
      sha256 = "396ed624f42177b28e406d0580755a5f15d33d0aafcf1f2b74f078d26a1e21c0";
    }
    {
      name = "vscode-guid";
      publisher = "heaths";
      version = "1.4.20";
      sha256 = "0hqzvwrl6s4s9mw71127a2vbp73bpn6zhlkma88qd5xpklxgw5ax";
    }
    {
      name = "better-toml";
      publisher = "bungcip";
      version = "0.3.2";
      sha256 = "08lhzhrn6p0xwi0hcyp6lj9bvpfj87vr99klzsiy8ji7621dzql3";
    }
  ];

  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in
{
  nixpkgs.overlays = [
    (self: super:
    {
      spotifyd = super.spotifyd.override {
        withPulseAudio = true;
        withMpris = true;
      };
    })
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "maxdeviant";
  home.homeDirectory = "/home/maxdeviant";

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
      set -gx PATH $PATH ~/.local/bin
      set -gx PATH $PATH ~/.scripts

      function gll
        git log --graph --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end

      function glll
        git log --graph --stat --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end
    '';
  };

  programs.bash.enable = true;

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

  home.packages = with pkgs; [
    # Utilities
    aseprite
    element-desktop
    ffmpeg
    nodePackages.vercel
    pick-colour-picker
    playerctl
    ripgrep
    sublime-merge
    xfce.thunar
    unzip
    vscode-with-extensions

    # Just for fun
    cmatrix
    cowsay

    # Applications
    discord
    spotify
    zoom-us

    # Games
    runelite
    steam
    lutris
    wine

    # VPN/Remote Desktop
    remmina
    sstp

    # Elm
    elmPackages.elm
    elmPackages.elm-format

    # Node
    nodejs
  ];

  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "maxdeviant";
        password_cmd = "/home/maxdeviant/.spotify_pass";
        device_name = "firelink_daemon";
        backend = "pulseaudio";
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      "
      " General
      "

      set encoding=utf-8
      set fileencoding=utf-8

      set number
      set ruler
      set showcmd
      set autoindent

      filetype plugin indent on
      set tabstop=4
      set shiftwidth=4
      set expandtab

      syntax on

      set ttyfast

      "
      " Keybinds
      "

      " Better Escape binding
      inoremap jj <Esc>

      " Don't use arrow keys!
      noremap <Up> <NOP>
      noremap <Down> <NOP>
      noremap <Left> <NOP>
      noremap <Right> <NOP>

      " Really, just don't.
      inoremap <Up> <NOP>
      inoremap <Down> <NOP>
      inoremap <Left> <NOP>
      inoremap <Right> <NOP>
    '';
  };

  programs.rofi = {
    enable = true;
    font = "Fira Code 16";
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = "android_notification";
  };
}
