{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAliases = {
      gs = "git status";
      gc = "git commit $argv";
      gca = "git add -A; and git commit $argv";
      gd = "git diff $argv";
      gl = "git log $argv";
      gp = "git pull $argv";
    };
  };

  programs.git = {
    enable = true;
    userName = "Marshall Bowers";
    userEmail = "elliott.codes@gmail.com";
  };

  home.packages = with pkgs; [
    discord
  ];

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
