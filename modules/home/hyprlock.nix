{ config, pkgs, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
        ignore_empty_input = true;
        grace = 1;
      };
      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easyOutQuint";
        };
        fade_out = {
          duration = 300;
          bezer = "easyOutQuint";
        };
      };
      background = [{
        path = "screenshot";
        blur_passes = 3;
        blur_size = 10;
      }];
      input-field = [{
        monitor = "";
        size = "220, 50";
        position = "0, -30";
        halign = "center";
        valign = "center";
        dots_center = true;
        font_color = "#ceccc8";
        inner_color = "#080f0d";
        outer_color = "rgba(0, 0, 0, 0)";
        font_family = "DM Mono";
        placeholder_text = "$USER";
        fail_text = "$PAMFAIL";
        rounding = 10;
        fade_on_empty = false;
      }];
      #Time
      label = [{
        monitor = "";
        text = "$TIME";
        font_size = 90;
        font_family = "DM Mono";
        position = "0, 90";
        halign = "center";
        valign = "center";
      }];
    };
  };
}
