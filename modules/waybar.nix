{ config, pkgs, ... }:

{
  # --- Waybar ---
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        mode = "dock";
        fixed-center = true;
        modules-left = [ "image" "custom/separator" "sway/workspaces" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "network" "custom/separator" "battery" "custom/separator" "clock" ];

        "sway/window" = {
          max-length = 50;
          tooltip = false;
        };
        "battery" = {
          format = "{capacity}%";
          format-charging = "{capacity}% (Charging)";
        };
        "clock" = {
          format = "{:%H:%M}";
          tooltip-format = "{:%A, %d. %B %Y}";
          timezone = "Europe/Berlin";
        };
        "network" = {
          format-wifi = "{essid} ({signalStrength}%)";
          format-ethernet = "{ifname}: {ipaddr}";
          format-disconnected = "Disconnected!";
          tooltip = false;
        };
        "image" = {
          path = toString ../resources/nix-snowflake-white.svg;
          size = 20;
          on-click = "firefox https://search.nixos.org/packages"; 
          tooltip-format = "Package Search";
        };
        "custom/separator" = {
          format = "|";
          interval = "once";
          tooltip = false;
        };
      };
    };
    style = ''
      @define-color background #080f0d;
      @define-color foreground white;
      @define-color pink #a1787f;

      * {
        border: none;
        border-radius: 0;
        font-family: "DM Mono", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: @background;
        border-bottom: 3px solid transparent;
        color: @foreground;
      }

      #workspaces button {
        padding: 0 5px;
        margin: 0 3px;
        color: @foreground;
      }

      #workspaces button.focused {
        background: rgba(100, 114, 125, 0.2);
        border-bottom: 3px solid @foreground;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #temperature, #backlight, #idle_inhibitor {
        padding: 0 6px;
        margin: 0 5px;
      }

      #image {
        padding: 0 4px;
        margin: 0 3px;
      }

      #clock {
        background-color: transparent;
        color: @foreground;
      }

      #battery {
        color: @foreground;
      }

      #battery.charging {
        color: @foreground;
      }

      #network {
        background: transparent;
        color: @foreground;
      }

      #network.disconnected {
        background: transparent;
        color: @pink;
      }

      #pulseaudio {
        background: transparent;
        color: @foreground;
      }

      #pulseaudio.muted {
        border-bottom: 3px solid @pink;
      }
  
      #custom-separator {
        color: @foreground;
      }
    '';
  };
}
