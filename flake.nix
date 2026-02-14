{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    affinity-nix.url = "github:mrshmllow/affinity-nix";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, affinity-nix, ... }: {
    nixosConfigurations.chervil = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.etcvi = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit affinity-nix; };
        }
      ];
    };
  };
}
