{ config, pkgs, ... }:

{
  # Main dnsmasq instance for LAN clients
  services.dnsmasq = {
    enable = true;
    
    settings = {
      interface = [ "enp1s0" "tailscale0" "lo" ];
      bind-interfaces = true;
      no-resolv = true;
      enable-ra = false;
      
      # Upstream DNS servers
      server = [
        "9.9.9.9"
        "149.112.112.112"
        "2620:fe::fe"
        "2620:fe::9"
      ];
      
      # Local domain
      domain = "etcvi.lan";
      expand-hosts = true;
      
      # Cache settings
      cache-size = 1000;

      addn-hosts = [
        "/etc/dnsmasq-hosts-lan"
        "/etc/dnsmasq-hosts-tailscale"
      ];

      host-record = [
        "paperless.etcvi.lan,fd5f:177d:18ff:0::10"
        "irc.etcvi.lan,fd5f:177d:18ff:0::10"
        "jelly.etcvi.lan,fd5f:177d:18ff:0::10"
        "navi.etcvi.lan,fd5f:177d:18ff:0::10"
      ];
    };
  };
  
  # Open firewall for DNS on both interfaces
  networking.firewall = {
    interfaces = {
      "enp1s0" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
      "tailscale0" = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };
    };
  };

  environment.etc."dnsmasq-hosts-lan".text = ''
    192.168.42.10 paperless.etcvi.lan
    192.168.42.10 irc.etcvi.lan
    192.168.42.10 jelly.etcvi.lan
    192.168.42.10 navi.etcvi.lan
  '';

  environment.etc."dnsmasq-hosts-tailscale".text = ''
    100.102.19.110 paperless.etcvi.lan
    100.102.19.110 irc.etcvi.lan
    100.102.19.110 jelly.etcvi.lan
    100.102.19.110 navi.etcvi.lan
  '';
}
