{ ... }:

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

    initContent = ''
      _nixos_rebuild_check() {
        local last_cmd
        last_cmd=$(fc -ln -1 2>/dev/null | sed 's/^[[:space:]]*//')
        local flag="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/nixos-test-pending"

        case "$last_cmd" in
          *nixos-rebuild\ test*)
            touch /var/run/nixos-test-pending
            ;;
          *nixos-rebuild\ switch*|*nixos-rebuild\ boot*)
            rm -f /var/run/nixos-test-pending
            ;;
        esac
      }

      precmd_functions+=(_nixos_rebuild_check)
    '';
  };
}
