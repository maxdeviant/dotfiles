{ config, pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.Nix
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "night-owl";
      publisher = "sdras";
      version = "2.0.0";
      sha256 = "1s75bp9jdrbqiimf7r36hib64dd83ymqyml7j7726rab0fvggs8b";
    }
    {
      name = "nix-env-selector";
      publisher = "arrterian";
      version = "0.1.2";
      sha256 = "1n5ilw1k29km9b0yzfd32m8gvwa2xhh6156d4dys6l8sbfpp2cv9";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.3.0";
      sha256 = "1285bs89d7hqn8h8jyxww7712070zw2ccrgy6aswd39arscniffs";
    }
    {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.4";
      sha256 = "16c6ik09wj87r0dg4l0swl2qlqy48jkavpp5i90l166x2mjw2b7w";
    }
    {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.23.2";
      sha256 = "18qnipa8av2xirpzsihljvvp97vzbx28s9gcqg3q7fqbyl127xjn";
    }
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.8";
      sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
    }
    {
      name = "prettier-vscode";
      publisher = "esbenp";
      version = "5.7.1";
      sha256 = "0f2q17d028j2c816rns9hi2w38ln3mssdcgzm6kc948ih252jflr";
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
    now-cli
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
