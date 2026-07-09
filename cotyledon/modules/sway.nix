{ pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd.variables = ["--all"];   
    checkConfig = true;
    extraConfig = ''
      default_border none
    '';
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      defaultWorkspace = "workspace 1";
      bars = [{
        command = "waybar";
      }];
      fonts = {
        names = [ "DM Mono" ];
        size = "12";
      };
      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "us,de";
	      };
        "2:10:TPPS/2_Elan_TrackPoint" = {
          accel_profile = "flat";
          pointer_accel = "0.3"; # -1.0 to 1.0
        };
      };
      output = {
        "*" = {
          bg = "#52525C solid_color";
        };
      };
      floating = {
        modifier = "Mod4";
        criteria = [
          {
            app_id = "swayimg";
          }
        ];
      };
      window.commands = [
        {
          command = "floating enable, resize set width 1000 height 900, move position 5 ppt 90";
          criteria = { app_id = "Alacritty"; };
        }
      ];
      colors = {
        focused = {
          background = "#080f0d";
          indicator = "#2e9ef4";
          text = "#FFFFFF";
          border = "#080f0d";
      	  childBorder = "#080f0d";
        };
        focusedInactive = {
          background = "080f0d";
          text = "#71717b";
          border = "#080f0d";
      	  childBorder = "#080f0d";
      	  indicator = "#080f0d";
        };
        unfocused = {
          background = "080f0d";
          text = "#71717b";
          border = "#080f0d";
      	  childBorder = "#080f0d";
  	      indicator = "#080f0d";
        };
      };
      keybindings = 
        let
          mod = "Mod4";
          left = "Left";
          right = "Right";
          up = "Up";
          down = "Down";
        in
        {
          # Open terminal
          "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
      	  # Quit application
          "${mod}+Shift+q" = "kill";
	        # Show application Launcher
          "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
      	  # Lock screen
          "${mod}+l" = "exec ${pkgs.hyprlock}/bin/hyprlock";
      	  # Reload the configuration file
          "${mod}+Shift+c" = "reload";
          # Exit sway
          "${mod}+Shift+e" = "exec swaynag -t warning -m 'Really exit sway? This will end your wayland session.' -B 'Yes, exit sway' 'swaymsg exit'";

          # Screenshot
          "Print" = "exec grimshot --notify copy area";

          # Change focus
          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          # Move focused window
          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          # switch to workspace
          "${mod}+1" = "workspace 1";
          "${mod}+2" = "workspace 2";
          "${mod}+3" = "workspace 3";
          "${mod}+4" = "workspace 4";
          "${mod}+5" = "workspace 5";
          "${mod}+6" = "workspace 6";
          "${mod}+7" = "workspace 7";
          "${mod}+8" = "workspace 8";
          "${mod}+9" = "workspace 9";
          "${mod}+0" = "workspace 10";

          # move focused container to workspace
          "${mod}+Shift+1" = "move container to workspace 1";
          "${mod}+Shift+2" = "move container to workspace 2";
          "${mod}+Shift+3" = "move container to workspace 3";
          "${mod}+Shift+4" = "move container to workspace 4";
          "${mod}+Shift+5" = "move container to workspace 5";
          "${mod}+Shift+6" = "move container to workspace 6";
          "${mod}+Shift+7" = "move container to workspace 7";
          "${mod}+Shift+8" = "move container to workspace 8";
          "${mod}+Shift+9" = "move container to workspace 9";
          "${mod}+Shift+0" = "move container to workspace 10";

      	  # Split focused object
      	  "${mod}+b" = "splith";
      	  "${mod}+v" = "splitv";

          # Switch the current container between different layout styles
          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          # Make the current focus fullscreen
          "${mod}+f" = "fullscreen";
      	  # Move focus to parent container
      	  "${mod}+a" = "focus parent";

      	  # Move focused window to scratchpad
      	  "${mod}+Shift+minus" = "move scratchpad";
      	  # Show next scratchpad window or hide focused scratchpad window
          "${mod}+minus" = "scratchpad show";
          
          # Toggle the current focus between tiling and floating mode
          "${mod}+Shift+space" = "floating toggle";
          # Swap focus between the tiling area and the floating area
          "${mod}+space" = "focus mode_toggle";
          
          # Switch keyboard layout
      	  "${mod}+tab" = ''exec swaymsg input "1:1:AT_Translated_Set_2_keyboard" xkb_switch_layout next'';

          # Enter resize mode
          "${mod}+r" = ''mode "resize"'';

          # Brightness
          "XF86MonBrightnessDown" = "exec swayosd-client --brightness -10";
          "XF86MonBrightnessUp" = "exec swayosd-client --brightness +10";
      };
      modes = {
        resize = {
          # Binds arrow keys to resizing commands
          "Left" = "resize shrink width 10 px";
          "Down" = "resize grow height 10 px";
          "Up" = "resize shrink height 10 px";
          "Right" = "resize grow width 10 px";

          # Exit resize mode
          "Escape" = "mode default";
          "Return" = "mode default";
        };
      };
    };
  };
}
