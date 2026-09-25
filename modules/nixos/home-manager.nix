# Wires Home Manager into the system evaluation, so that a single
# `nixos-rebuild switch` builds and activates both halves of the configuration
# into one generation that rolls back as a unit.
{ config, inputs, ... }:

let
  cfg = config.maxdeviant;
in
{
  home-manager = {
    # Use the system's nixpkgs instance rather than instantiating a second one.
    # Overlays and allowUnfree then get configured in exactly one place.
    useGlobalPkgs = true;

    # Install home.packages into /etc/profiles/per-user/$USER rather than
    # ~/.nix-profile, which makes them part of the system generation.
    useUserPackages = true;

    # Move pre-existing dotfiles aside on first activation instead of aborting.
    backupFileExtension = "hm-bak";

    extraSpecialArgs = { inherit inputs; };

    # Give the Home Manager evaluation the same option schema the system has.
    sharedModules = [ ../options.nix ];

    users.${cfg.identity.username} = {
      imports = [ ../home ];

      # Mirror the evaluated values across the system/home boundary. Home
      # modules read config.maxdeviant.* exactly like system modules do, rather
      # than reaching into `osConfig`, which would tie them to NixOS.
      maxdeviant = { inherit (cfg) identity theme roles desktopEnvironment; };
    };
  };
}
