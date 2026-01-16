{ config, pkgs, ... }:

{
 # --- Rofi ---
 programs.rofi = {
   enable = true;
   theme = "/etc/nixos/modules/rofi/style-10.rasi";
   font = "DM Mono";
   extraConfig = {
     show-icons = true;
   };
 };
}
