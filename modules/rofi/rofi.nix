{ config, pkgs, ... }:

{
 # --- Rofi ---
 programs.rofi = {
   enable = true;
   theme = "./style-10.rasi";
   font = "DM Mono";
   extraConfig = {
     show-icons = true;
   };
 };
}
