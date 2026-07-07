{ pkgs, ... }:

{
  imports = [
    ./modules/nvim.nix
    ./modules/sway.nix
    ./modules/waybar.nix
    ./modules/rofi/rofi.nix
  ];
  
  home.username = "viewer";
  home.homeDirectory = "/home/viewer";

  home.packages = with pkgs; [
    libnotify
    swaybg
  ];

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.npm-global/node_modules/.bin"
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.git = {
    enable = true;
    settings.init = {
        defaultBranch = "main";
    };
    settings.user = {
        name = "Viktoria K.";
        email = "122076719+toridotzip@users.noreply.github.com";
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal = {
        shell = { program = "${pkgs.zsh}/bin/zsh"; };
      };
      window = {
        padding = { x = 10; y = 10; };
        dynamic_padding = false;
        decorations_theme_variant = "Dark";
      };
      cursor = {
        style = { shape = "Beam"; blinking = "On"; };
      };
      font = {
        normal = { family = "DM Mono"; style = "Regular"; };
        size = 11;
      };
    };
  }; 

  services.mako = {
    enable = true;
    settings = {
      font = "monospace 10";
      background-color = "#080f0d";
      border-size = 0;
      margin = 10;
      padding = 8;
      width = 250;
      height = 100;
      progress-color = "source #ffffff";
      default-timeout = 5000;
    };
  }; 
}
