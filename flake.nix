{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = { 
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
      };
    };
 };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, agenix, ... }: 
    let
      commonModules = [
        agenix.nixosModules.default
        home-manager.nixosModules.home-manager
        {
          environment.systemPackages = [
            agenix.packages.x86_64-linux.default
          ];
        }
      ];
    in {
      nixosConfigurations = { 
        chervil = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./configuration.nix
          ];
        };
        thyme = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./configuration-thyme.nix
            {
              home-manager.useUserPackages = true;
              home-manager.users.etcvi = import ./home-thyme.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
      };
    };
}
