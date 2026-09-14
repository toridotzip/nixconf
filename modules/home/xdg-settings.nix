{ ... }:

{
  xdg.desktopEntries = {
    wiremix = {
      name = "Wiremix";
      genericName = "Pipewire Mixer";
      exec = "alacritty --title wiremix -e wiremix";
      terminal = false;
      type = "Application";
      categories = [ "AudioVideo" "Audio" "Mixer" ];
      icon = "multimedia-volume-control";
    };
  };

  xdg.configFile."wireplumber/wireplumber.conf.d/51-ag06-volume.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          { device.name = "alsa_card.usb-Yamaha_Corporation_AG06_AG03-00" }
        ]
        actions = {
          update-props = {
            device.routes.default-sink-volume = 1.0
            device.routes.default-source-volume = 1.0
          }
        }
      }
    ]
  '';

  xdg.configFile."sunsetr/sunsetr.toml".text = ''
    backend = "auto"
    transition_mode = "geo"

    smoothing = true
    startup_duration = 10
    shutdown_duration = 10
    
    night_temp = 4000
    day_temp = 6500
    night_gamma = 90
    day_gamma = 100
    update_interval = "auto"

    static_temp = 6500
    static_gamma = 100

    latitude = 52.55092
    longitude = 13.384846
  '';
}
