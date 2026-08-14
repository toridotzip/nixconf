{ pkgs, ... }:

{
  imports = [
    ./modules/home/shell.nix
    ./modules/home/nvim.nix
  ];

  home.username = "etcvi";
  home.homeDirectory = "/home/etcvi";

  home.stateVersion = "25.11";
  
  programs.home-manager.enable = true;

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    terminal = "tmux-256color";
    extraConfig = ''
      set -ga terminal-overrides ",*256col*:Tc"
      set -g escape-time 10
    '';
    plugins = with pkgs.tmuxPlugins; [
      resurrect
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
    ];
  };
}
