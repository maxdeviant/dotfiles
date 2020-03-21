{ config, pkgs, ... }:

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
    ripgrep
    sublime-merge
    unzip
    vscode

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
