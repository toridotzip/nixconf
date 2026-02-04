{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "DM Mono";
      size = 12;
    };
    themeFile = "../resources/kitty/aura-theme"
  };
}
