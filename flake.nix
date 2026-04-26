{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix = {
      url = "github:ryantm/agenix";
      inputs = { 
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
      };
    };
 };

  outputs = inputs@{ self, nixpkgs, home-manager, agenix, ... }: 
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
            {
              # home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.etcvi = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
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
