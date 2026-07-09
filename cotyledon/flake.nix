{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, home-manager, ... }: {
    nixosConfigurations.cotyledon = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./cotyledon.nix
        ./hardware-configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.etcvi = import ./home.nix;
        }
      ];
    };
  };
}
