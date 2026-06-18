# Home manager
{ config, pkgs, inputs, ... }:

{
  imports = [ 
    ./modules/home/secrets.nix
    ./modules/home/shell.nix
    ./modules/home/sway.nix 
    ./modules/home/waybar.nix
    ./modules/home/hyprlock.nix
    ./modules/home/rofi/rofi.nix
    ./modules/home/nvim.nix
    ./modules/home/librewolf.nix
    ./modules/home/neomutt.nix
    ./modules/home/waypaper.nix
    ./modules/home/yazi.nix
    ./modules/home/zathura.nix
  ];

  home.username = "etcvi";
  home.homeDirectory = "/home/etcvi";

  home.packages = with pkgs; [
    grim
    slurp
    sway-contrib.grimshot
    git-credential-manager
    libnotify
    trash-cli
    playerctl
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.npm-global/node_modules/.bin"
  ];

  home.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.git = {
    enable = true;
    settings.init = {
        defaultBranch = "main";
    };
    settings.user = {
        name = "Viktoria K.";
        email = "122076719+toridotzip@users.noreply.github.com";
    };
  };

  programs.lf = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";
      window_padding_width = 10;
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      font_family = "DM Mono";
      font_size = 11;
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal = {
        shell = { program = "${pkgs.zsh}/bin/zsh"; };
      };
      window = {
        padding = { x = 10; y = 10; };
        dynamic_padding = false;
        decorations_theme_variant = "Dark";
      };
      cursor = {
        style = { shape = "Beam"; blinking = "On"; };
      };
      font = {
        normal = { family = "DM Mono"; style = "Regular"; };
        size = 11;
      };
    };
    theme = "aura";
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--ozone-platform=wayland"
      "--enable-features=WebRTCPipeWireCapturer"
    ];
  };
  
  programs.vesktop = {
    enable = false;
    vencord = {
      settings = {
        autoUpdate = true;
        autoUpdateNotification = true;
        notifyAboutUpdates = true;
        plugins = {
          AlwaysTrust.enabled = true;
          ClearURLs.enabled = true;
          FixYoutubeEmbeds.enabled = true;
          IrcColors.enabled = true;
          LoadingQuotes.enabled = true;
          NoTrack.enabled = true;
          OnePingPerDM.enabled = true;
          QuickReply.enabled = true;
          ShowMeYourName.enabled = true;
          TypingTweaks.enabled = true;
        };
      };
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  services.swayosd = {
    enable = true;
    stylePath = toString ./resources/swayosd/style.css;
  };

  services.mako = {
    enable = true;
    settings = {
      font = "monospace 10";
      background-color = "#080f0d";
      border-size = 0;
      margin = 10;
      padding = 8;
      width = 250;
      height = 100;
      progress-color = "source #ffffff";
      default-timeout = 5000;
    };
  };

  systemd.user.services.screenbreak-reminder = {
    Unit = {
      Description = "Screenbreak reminder notification";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.libnotify}/bin/notify-send -u normal 'Screen Break' 'Time to take a 20-second break! Look away from your screen.' -t 10000";
    };
  };

  systemd.user.timers.screenbreak-reminder = {
    Unit = {
      Description = "Timer for screenbreak reminders";
    };
    Timer = {
      OnBootSec = "20min";
      OnUnitActiveSec = "20min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "small";
      	source = "nixos";
      };
      display = {
        separator = ": ";
      };
      modules = [
        "title"
        "chassis"
        {
            type = "os";
            format = "{pretty-name} {version-id} {arch}";
        }
	      "uptime"
        {
            type = "cpu";
            showPeCoreCount = true;
            temp = true;
        }
        {
            type = "disk";
            key = "Disk";
            folders = "/";
        }
        {
            type = "localip";
            key = "LAN IP";
            showIpv6 = true;
            showPrefixLen = false;
        }
        {
            type = "publicip";
            key = "WAN IP";
            timeout = 1000;
        }	
      ];
    };
  };

  fonts = {
    fontconfig.enable = true;
    fontconfig.defaultFonts.monospace = [ "DM Mono" ];
    fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];
  };
}
