{ config, pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.Nix
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "night-owl";
      publisher = "sdras";
      version = "1.1.3";
      sha256 = "b7a0859f0d976d5f46a266e93a8b989ce3acd5423021265d61dd5c57fda1a9b5";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.2";
      sha256 = "693371af5b1a51a37d23cd946020ec42f1fd5015a3b9efc14a75263103a7b1d8";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "2.7.0";
      sha256 = "85d1ca78376e62a81c06acc27047ecbc674800ed73acc8625bdb0315deead6fc";
    }
    {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "4.2.0";
      sha256 = "aa06fd553445d32034fde7ff3b90ba45550ea585d4ec2a1193f39acc89d0e6c9";
    }
    {
      name = "vscode-guid";
      publisher = "heaths";
      version = "1.4.19";
      sha256 = "43359327721e6cfb1effb8d6a34370c8fb2eb5a89e9ca219f0e0ba49d3fce24c";
    }
    {
      name = "better-toml";
      publisher = "bungcip";
      version = "0.3.2";
      sha256 = "83e2df8230274ae4a3fe74a694f741d2ddbd92a4e67a0641e41d5c6333fc9022";
    }
  ];

  vscode-with-extensions = pkgs.vscode-with-extensions.override {
    vscodeExtensions = extensions;
  };
in
{
  programs.home-manager.enable = true;

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

      function gll
        git log --graph --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end

      function glll
        git log --graph --stat --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'
      end
    '';
  };

  programs.git = {
    enable = true;
    userName = "Marshall Bowers";
    userEmail = "elliott.codes@gmail.com";
  };

  home.packages = with pkgs; [
    # Utilities
    aseprite
    ffmpeg
    now-cli
    playerctl
    riot-desktop
    ripgrep
    sublime-merge
    unzip
    vscode-with-extensions

    # Just for fun
    cmatrix
    cowsay

    # Applications
    discord
    spotify

    # Games
    runelite

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
}
