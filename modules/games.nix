{ pkgs, ... }:

{
    users.users.etcvi.packages = with pkgs; [
        itch
        protonup-qt
        heroic
        gamemode
        retroarch-assets
        libretro.pcsx2
    ];

    programs.steam = {
        enable = true;
    };

    programs.gamemode = {
      enable = true;
      settings = {
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

  home-manager.users.etcvi = {
    programs.retroarch = {
      enable = true;
      cores = {
        pcsx2.enable = true;
      };
      settings = {
        video-driver = "glcore";
      };
    };
  };
}
