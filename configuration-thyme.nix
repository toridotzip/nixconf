{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration-thyme.nix
      ./modules/thyme/dnsmasq.nix
      ./modules/thyme/caddy.nix
      ./docker/navidrome.nix
      ./docker/jellyfin.nix
      ./docker/thelounge.nix
      ./modules/thyme/paperless.nix
      ./modules/thyme/dufs.nix
      ./modules/thyme/calibre.nix
    ];

  age.secrets.syncthing-gui-thyme = {
    file = ./secrets/syncthing-gui-thyme.age;
    owner = "etcvi";
    mode = "400";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.extraModprobeConfig = "install algif_aead /bin/false";

  networking = {
    hostName = "thyme";
    networkmanager.enable = false;
    interfaces.enp1s0 = {
      ipv4.addresses = [{
        address = "192.168.42.10";
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = "fd5f:177d:18ff:0::10";
        prefixLength = 64;
      }];
    };
    defaultGateway = {
      address = "192.168.42.1";
    };
    defaultGateway6 = {
      address = "fe80::1eed:6fff:fe5c:b8b6";
      interface = "enp1s0";
    };
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        8384  # Syncthing GUI
        22000 # Syncthing data
        28981 # Paperless
        5000  # Dufs
        8080  # Calibre
      ];
      allowedUDPPorts = [
        21027 # Syncthing discovery
      ];
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/2C8EA1DA8EA19D38";
    fsType = "ntfs";
    options = [
      "nofail"
      "exec"
    ];
  };

  users.users.etcvi = {
    isNormalUser = true;
    description = "etcvi";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSGTYTcDagkYliV1tdRD9W3o5imsaOr2BnjNrbASHCs tori@parsley"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHJhW2kgom8HVqLBUhpQGwxrCKxccbiLgNLoqZA5Kse/ etcvi@chervil"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISnqAIMcrE38HLDFP8zM7QKQ0PA91RSVuxZj9SCAn+E rosemary"
    ];
  };

  programs.zsh.enable = true;

  # --- Packages ---

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    nano
    git
    compose2nix
    tailscale
    figlet
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [ "9.9.9.9" "149.112.112.112" ];
    };
  };

  programs.rust-motd = {
    enable = true;
    settings = {
      banner = {
        color = "green";
        command = "cat /etc/nixos/resources/banner.txt";
      };
      uptime = { prefix = "Uptime"; };
      last_login = { etcvi = 2; };
      docker = {
        "/jellyfin" = "jellyfin";
        "/thelounge" = "irc";
      };
      filesystems = {
        root = "/";
        media = "/mnt/media";
      };
      fail_2_ban = {
        jails = ["sshd"];
      };
    };
    enableMotdInSSHD = true;
  };

  # --- Services ---

  services.openssh = {
    enable = true;
    ports = [ 7643 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "etcvi" ];
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "192.168.42.0/24"
    ];
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    guiPasswordFile = config.age.secrets.syncthing-gui-thyme.path;
    user = "etcvi";
    configDir = "/home/etcvi/syncthing/config";
    dataDir = "/home/etcvi/syncthing/data";
    settings = {
      devices = {
        "Parsley" = { id = "EGA7AYA-PZC6GZC-H5GMLTN-LNLDX24-KYSIULI-B3MGHVT-H46Q4VC-7XWJEQU"; };
      };
      folders = {
        "music" = {
          id = "hucqa-g5qtw";
          path = "/mnt/media/music";
          type = "receiveonly";
          devices = [ "Parsley" ];
        };
      };
    };
  };
  
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";

    extraUpFlags = [
      "--accept-dns=false"
      "--advertise-tags=tag:dns"
    ];
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  system.stateVersion = "25.11"; # Did you read the comment?

}
