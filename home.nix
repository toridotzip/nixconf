# Home manager
{ config, pkgs, ... }:

{
  imports = [ 
    ./modules/sway.nix 
    ./modules/waybar.nix
    ./modules/hyprlock.nix
    ./modules/rofi/rofi.nix
    ./modules/nvim.nix
  ];

  home.username = "etcvi";
  home.homeDirectory = "/home/etcvi";

  home.packages = [
    pkgs.grim
    pkgs.slurp
    pkgs.sway-contrib.grimshot
    pkgs.git-credential-manager
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      rebuild-switch = "sudo nixos-rebuild switch";
      rebuild-boot = "sudo nixos-rebuild boot";
      rebuild-test = "sudo nixos-rebuild test";
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "cp *"];

    oh-my-zsh = {
      enable = true;
      # custom = "/etc/nixos/resources/omz";
      theme = "mh";
      plugins = [
        "git"
      ];
    };
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
  
  programs.vesktop = {
    enable = true;
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
        # enabledThemes = [ "midnight.css" ];
      };
      themes = { 
        "midnight" = /etc/nixos/modules/vesktop/midnight.theme.css; 
      };
    };
  };

  services.swayosd = {
    enable = true;
    stylePath = "/etc/nixos/resources/swayosd/style.css";
  };

  services.mako = {
    enable = true;  	
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
