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
