{ config, pkgs, ... }:

{
 # --- Rofi ---
 programs.rofi = {
   enable = true;
   theme = toString ./style-10.rasi;
   font = "DM Mono";
   extraConfig = {
     show-icons = true;
   };
 };
}
