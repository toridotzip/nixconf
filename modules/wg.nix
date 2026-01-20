{ pkgs, ... }:

{
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [
        "192.168.19.1/32"
      ];
      dns = [ "192.168.18.1" ];
      privateKey = "yK4zsxoWozNjl8vUh1PADX0L25ZZA0A/cPV28kaLRWU=";
      peers = [
        {
          publicKey = "itkgBA10kNNewLqGHbnBV5k5K0YbdO89HQmVLyyDvAo=";
          allowedIPs = [
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = "172.16.155.10:51820"
        };
      ];
    };
  };
}
