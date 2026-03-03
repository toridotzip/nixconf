{ config, pkgs, ... }:

{

  home.packages = [
    pkgs.swaybg
    pkgs.waypaper
  ];

  home.file.".config/waypaper/config.ini".text = ''
    [Settings]
    folder = ~/Pictures/Wallpapers
    backend = swaybg
    zen_mode = True
    post_command = pkill waypaper
    stylesheet = ~/.config/waypaper/style.css
  '';

  home.file.".config/waypaper/style.css".text = ''
    window {
      background-color: rgba(8, 15, 13, 0.3);
    }
  '';

}
