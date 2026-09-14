{ lib, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    flavors = {
      flexoki-dark = pkgs.fetchFromGitHub {
        owner = "gosxrgxx";
        repo = "flexoki-dark.yazi";
        rev = "25d28ce199a5189dbad5d17a526d0ebdece63532";
        sha256 = "sha256-z8USdFAWqDl+8+aM83Hy0Wjjkdq62LC5PwcVpDMOWWY=";
      };
    };
    theme.flavor = {
      dark = "flexoki-dark";
    };
    settings = {
      mgr = {
        show_hidden = false;
      };
      opener = {
        zathura = [
          { run = ''zathura "$@"''; orphan = true; desc = "Open in zathura"; }
        ];
        swayimg = [
          { run = ''swayimg "$@"''; orphan = true; desc = "Open with swayimg"; }
        ];
      };
      open = {
        prepend_rules = [
          { mime = "application/pdf"; use = "zathura"; }
          { mime = "image/*"; use = "swayimg"; }
        ];
      };
    };
    vfs = {
      services = {
        thyme-local = {
          type = "sftp";
          host = "192.168.42.10";
          user = "etcvi";
          port = 7643;
          key_file = "~/.ssh/thyme";
        };
      };
    };
    plugins = {
      full-border = {
        package = pkgs.yaziPlugins.full-border;
        setup = true;
        settings = {
           type = lib.mkLuaInline "ui.Border.PLAIN";
        };
      };
    };
  };

  home.packages = with pkgs; [
    ueberzugpp
    poppler-utils
  ];
}
