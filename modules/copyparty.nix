{ lib, pkgs, ... }:
let
  copyparty = fetchTarball {
    url = "https://github.com/9001/copyparty/archive/hovudstraum.tar.gz";
    sha256 = "11rrp5n9jdiv0l4fxy8xxq07icglfvbzrbb6khbryxsw7p72b8pd";
  };
in
{
  imports = [ "${copyparty}/contrib/nixos/modules/copyparty.nix" ];
  
  nixpkgs.overlays = [ (import "${copyparty}/contrib/package/nix/overlay.nix") ];
  environment.systemPackages = [ pkgs.copyparty ];
  
  services.copyparty = {
    enable = true;
    group = "copyparty";
    settings = {
      i = "0.0.0.0";
      p = "10100";
    };
    accounts = {
      tori.passwordFile = "/run/keys/copyparty/tori_pw";
    };
    #groups = {
    #  g1 = [ "tori" ];
    #};
    volumes = {
      "/" = {
        path = "/srv/copyparty";
        access = {
          r = "*";
          rw = [ "tori" ];
        };
        flags = {
          fk = 4;
          scan = 60;
          e2d = true;
          d2t = true;
          nohash = "\.iso$";
        };
      };
    };
    # openFilesLimit = 8192;
  };

  systemd.services.copyparty = { 
    wantedBy = lib.mkForce [ ];
    serviceConfig.AmbientCapabilities = "CAP_NET_BIND_SERVICE";
  };
}
