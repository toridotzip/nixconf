{ lib, pkgs, config, ... }:

{
  home.packages = let
    waypaper-wrapped = pkgs.writeShellScriptBin "waypaper" ''
      CONFIG_FILE="$HOME/.config/waypaper/config.ini"
      
      # Create config if it doesn't exist
      if [ ! -f "$CONFIG_FILE" ]; then
        mkdir -p "$(dirname "$CONFIG_FILE")"
        cat > "$CONFIG_FILE" << 'EOF'
  [Settings]
  folder = ~/Pictures/Wallpapers
  backend = swaybg
  zen_mode = True
  color = #080f0d
  subfolders = False
  post_command = pkill waypaper
  stylesheet = $HOME/.config/waypaper/style.css
  EOF
      fi
      
      # Update our desired settings before launching
      ${pkgs.gnused}/bin/sed -i \
        -e 's/^color = .*/color = #080f0d/' \
        -e 's/^subfolders = .*/subfolders = False/' \
        -e "s|^stylesheet = .*|stylesheet = $HOME/.config/waypaper/style.css|" \
        -e 's|^folder = .*|folder = ~/Pictures/Wallpapers|' \
        "$CONFIG_FILE"
      
      # Launch the real waypaper
      exec ${pkgs.waypaper}/bin/waypaper "$@"
    '';
  in [ waypaper-wrapped pkgs.swaybg ];

  xdg.desktopEntries.waypaper = {
    name = "Waypaper";
    genericName = "Wallpaper Setter";
    exec = "waypaper";
    terminal = false;
    categories = [ "Utility" "Graphics" ];
    icon = "waypaper";
  };

  home.file.".config/waypaper/style.css".text = ''
    window {
      background-color: rgba(8, 15, 13, 1);
    }
    
    /* Reset all button styling */
    button {
      background-image: none;
      background-color: transparent;
      box-shadow: none;
      border: none;
      outline: none;
      padding: 4px;
    }
    
    button image {
      border: none;
      outline: none;
      -gtk-icon-shadow: none;
      -gtk-icon-effect: none;
    }
    
    button:hover {
      background-image: none;
      background-color: transparent;
      box-shadow: none;
      border: none;
      outline: none;
    }
    
    button:hover image {
      border: none;
      -gtk-icon-shadow: none;
      -gtk-icon-effect: none;
    }
    
    /* Selected thumbnail - only bottom border */
    .highlighted-button {
      background-image: none;
      background-color: transparent;
      box-shadow: none;
      border: none;
      outline: none;
    }
    
    .highlighted-button image,
    .highlighted-button:hover image {
      border: none;
      border-bottom: 2px solid white;
      -gtk-icon-effect: none;
      -gtk-icon-shadow: none;
      outline: none;
    }
  '';
}
