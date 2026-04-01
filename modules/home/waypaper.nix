{ lib, pkgs, ... }:

{
  home.packages = [
    pkgs.swaybg
    pkgs.waypaper
  ];
  
  home.file.".config/waypaper/style.css".text = ''
    window {
      background-color: rgba(8, 15, 13, 0.3);
    }
  '';
  
  home.activation.waypaperConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    CONFIG_FILE="$HOME/.config/waypaper/config.ini"
    if [ ! -f "$CONFIG_FILE" ]; then
      mkdir -p "$(dirname "$CONFIG_FILE")"
      cat > "$CONFIG_FILE" << 'EOF'
    [Settings]
    folder = ~/Pictures/Wallpapers
    backend = swaybg
    zen_mode = True
    color = #080f0d
    subfolders = True
    post_command = pkill waypaper
    stylesheet = ~/.config/waypaper/style.css
    EOF
    fi
  '';
}
