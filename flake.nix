{
  description = "NixOS Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
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
          home-manager.sharedModules = [
            agenix.homeManagerModules.default
          ]; 
        }
      ];
    in {
      nixosConfigurations = { 
        chervil = nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit inputs; 
            pkgs-unstable = import inputs.nixpkgs-unstable {
              system = "x86_64-linux";
            };
          };
          modules = commonModules ++ [
            ./configuration.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
            {
              home-manager.useUserPackages = true;
              home-manager.users.etcvi = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
        thyme = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = commonModules ++ [
            ./configuration-thyme.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
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
