{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      rebuild-switch = "sudo nixos-rebuild switch";
      rebuild-boot = "sudo nixos-rebuild boot";
      rebuild-test = "sudo nixos-rebuild test";
      rm = ''echo "Are you sure you don't want to trash instead?"'';
    };

    history.size = 10000;
    history.ignoreAllDups = true;
    history.path = "$HOME/.zsh_history";
    history.ignorePatterns = ["rm *" "cp *"];

    oh-my-zsh = {
      enable = true;
      theme = "mh";
      plugins = [
        "git"
      ];
    };
  };
}
