{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      # <home-manager/nixos>
      ./modules/vscode.nix
      ./modules/copyparty.nix
    ];

  boot = {
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Use latest kernel.
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = [ "r8152" "cdc_ncm" ];
  };

  networking.hostName = "chervil"; # Define your hostname.

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    wifi.powersave = true;
    dns = "systemd-resolved";
  };
  
  networking.interfaces.tailscale0.useDHCP = false;

  networking.wireless.iwd = { 
    enable = true;
    settings = {
      General = {
        #  AddressRandomization = "network";
	      EnableNetworkConfiguration = true;
      };
      Network = {
        EnableIPv6 = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };
  };

  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
    "2620:fe::fe"
    "2620:fe::9"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    fallbackDns = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
  };
 
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 10100; to = 10110; }
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.etcvi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      nodejs
      itch
    ];
  };

  # Laptop Configs
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
  };

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 Elan TrackPoint";
    sensitivity = 50;
    speed = 10;
    inertia = 20;
    emulateWheel = true;
  };

  # --- Packages ---

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set up home manager
  home-manager.users.etcvi = import ./home.nix;

  environment.sessionVariables = { 
    LIBVA_DRIVER_NAME = "iHD"; 
    # PATH = [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nano
    wget
    curl
    tmux
    firefox
    pulseaudio
    gnome-keyring
    tailscale
    libsecret
    usbutils
    lshw
    swayimg
    signal-desktop
    protonup-qt
    heroic
    gnuradio
    rawtherapee
    nodejs
    gns3-gui
    gns3-server
    dynamips
    # jellyfin-media-player
  ];

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      PasswordManagerEnabled = false;
    };
  };

  programs.steam = {
    enable = true;
  };

  programs.zsh.enable = true;

  programs.light.enable = true;

  security.polkit.enable = true;

  # --- Services ---

  services.getty = {
    autologinUser = "etcvi";
    autologinOnce = true;
  };
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

  services.openssh.enable = true;

  services.xserver.videoDrivers = [ "modesetting" ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.tailscale.enable = true;
  
  services.gnome.gnome-keyring.enable = true;
  
  security.pam.services = { 
    hyprlock = {};
    sway.enableGnomeKeyring = true;
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  boot.tmp.cleanOnBoot = true;

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # --- Fonts ---

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      dm-mono
      ibm-plex
      dina-font
      nerd-fonts.noto
      noto-fonts-color-emoji
      fira-code-symbols
      dejavu_fonts
      liberation_ttf
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
