{ config, pkgs, ... }:

{
  imports = [
    ./modules/home/shell.nix
    ./modules/home/nvim.nix
  ];

  home.username = "etcvi";
  home.homeDirectory = "/home/etcvi";

  home.stateVersion = "25.11";
  
  programs.home-manager.enable = true;
}
