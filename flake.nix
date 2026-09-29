{
  description = "maxdeviant's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # master tracks nixpkgs-unstable; the release branches track the stable
      # channels. Since nixpkgs is on unstable here, this has to be master.
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Code updates faster than it lands in nixpkgs, so we pull it from a
    # dedicated flake that tracks upstream releases. Bump it on its own with
    # `nix flake update claude-code`.
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    {
      nixosConfigurations.nokron = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/options.nix
          ./modules/nixos
          ./hosts/nokron
        ];
      };
    };
}
