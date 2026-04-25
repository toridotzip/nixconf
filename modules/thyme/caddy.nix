{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;

    configFile = pkgs.writeText "Caddyfile" ''
      paperless.etcvi.lan {
        bind 0.0.0.0 [::]
        tls internal
        reverse_proxy localhost:28981
      }
      irc.etcvi.lan {
        bind 0.0.0.0 [::]
        tls internal
        reverse_proxy localhost:9000
      }
      jelly.etcvi.lan {
        bind 0.0.0.0 [::]
        tls internal
        reverse_proxy localhost:8096
      }
      navi.etcvi.lan {
        bind 0.0.0.0 [::]
        tls internal
        reverse_proxy localhost:4533
      }
    '';
  };

  networking.firewall = {
    interfaces = {
      "tailscale0" = {
        allowedTCPPorts = [ 80 443 ];
      };
    };
    extraCommands = ''
      iptables -A nixos-fw -p tcp --dport 80 -s 192.168.42.0/24 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp --dport 443 -s 192.168.42.0/24 -j nixos-fw-accept
      ip6tables -A nixos-fw -i enp1s0 -p tcp --dport 80 -j nixos-fw-accept
      ip6tables -A nixos-fw -i enp1s0 -p tcp --dport 443 -j nixos-fw-accept
    '';
  };
}
