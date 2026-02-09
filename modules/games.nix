{ pkgs, ... }:

{
    users.users.etcvi.packages = with pkgs; [
        itch
        protonup-qt
        heroic
        (retroarch.withCores (cores: with cores; [
            pcsx2
        ]))
        libretro.pcsx2
    ];

    programs.steam = {
        enable = true;
    };
}
