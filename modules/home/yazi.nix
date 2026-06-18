{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      mgr = {
        show_hidden = true;
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
  };

  home.packages = with pkgs; [
    ueberzugpp
    poppler-utils
  ];
}
