{ config, ... }:

{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "mqtt"
    ];
  };

  services.zigbee2mqtt = {
    enable = true;
    settings = {
      serial = {
        port = "/dev/serial/by-id/usb-Silicon_Labs_Sonoff_Zigbee_3.0_USB_Dongle_Plus_0001-if00-port0";
        adapter = "zstack";
      };
      mqtt = {
        base_topic = "zigbee2mqtt";
        server = "mqtt://127.0.0.1:1883";
      };
      homeassistant.enabled = true;
      permit_join = false;
      frontend = {
        enabled = true;
        host = "0.0.0.0"; 
        port = 8081; 
      };
      advanced = {
        channel = 25;
        network_key = "!secret network_key";
        ext_pan_id = "!secret ext_pan_id";
        pan_id = "!secret pan_id";
      };
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [{
      address = "127.0.0.1";
      port = 1883;
      users = {
        default = {
          hashedPasswordFile = config.age.secrets.mosquitto.path;
          acl = [
            "readwrite zigbee2mqtt/#"
            "readwrite homeassistant/#"
          ];
        };
      };
    }];
  };

  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p tcp -s 192.168.42.0/24 --dport 8081 -j nixos-fw-accept
  '';

  users.users.hass.extraGroups = [ "dialout" ];

  age.secrets = {
    z2m = {
      file = "../../secrets/z2m.age";
      owner = "zigbee2mqtt";
    };
    mosquitto = {
      file = "../../secrets/mosquitto.age";
      owner = "mosquitto";
    };
  };

  systemd.services.zigbee2mqtt.preStart = ''
    ln -sf ${config.age.secrets.z2m-secret.path} ${config.services.zigbee2mqtt.dataDir}/secret.yaml
  '';
}
