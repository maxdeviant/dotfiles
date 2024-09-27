# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    # "nodev" means we generate a GRUB boot menu but don't install GRUB.
    devices = [ "nodev" ];
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 50;
  };

  networking.hostName = "firelink"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/New_York";


  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    fira-code
  ];

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Window Manager
    bspwm
    sxhkd
    polybar
    xorg.xdpyinfo
    xautomation
    gnome.adwaita-icon-theme

    # Applications
    alacritty
    bat
    feh
    git
    htop
    maim
    neofetch
    neovim
    pavucontrol
    pciutils
    psmisc
    tailscale
    xclip
    wget

    ncmpcpp
    google-chrome
    tdesktop

    # Haskell
    stack

    # Python
    python3

    # Rust
    rustup
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  services.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  services.xserver.libinput.mouse.accelSpeed = "-0.5";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # We want the proprietary drivers.
    open = false;

    # This is needed for Wayland.
    modesetting.enable = true;

    # Fix screen tearing.
    forceFullCompositionPipeline = true;
  };

  # Enable Cinnamon.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.displayManager.defaultSession = "cinnamon";

  services.xserver.desktopManager.xterm.enable = false;

  programs.fish.enable = true;

  programs.ssh.startAgent = true;

  # Enable Postgres.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
  };

  # Enable 32-bit support for Steam.
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maxdeviant = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  users.defaultUserShell = "/run/current-system/sw/bin/fish";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

