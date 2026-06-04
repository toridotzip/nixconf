{ config, ... }:

{
  age.secrets.syncthing-gui = {
    file = ../secrets/syncthing-gui-chervil.age;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = false;
    guiAddress = "127.0.0.1:8384";
    guiPasswordFile = config.age.secrets.syncthing-gui.path;
    user = "etcvi";
    configDir = "/home/etcvi/syncthing/config";
    dataDir = "/home/etcvi/syncthing/data";
    settings = {
      gui.user = "etcvi";
      devices = {
        "Parsley" = { id = "EGA7AYA-PZC6GZC-H5GMLTN-LNLDX24-KYSIULI-B3MGHVT-H46Q4VC-7XWJEQU"; };
        "Rosemary" = { id = "6ESAEBR-TMM5AGD-HYFDQCM-TJBWIL2-WIAAD4F-OVB2SYP-CZ63RU2-HFMP3QB"; };
      };
      folders = {
        "Notes" = {
          path = "/home/etcvi/notes";
          devices = [ "Parsley" "Rosemary" ];
        };
      };
    };  
  };

  networking.firewall = {
    interfaces = {
      "tailscale0" = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [ 21027 ];
      };
    };
    extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 22000 -s 192.168.42.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p udp --dport 21027 -s 192.168.42.0/24 -j nixos-fw-accept
    '';
  };
}
