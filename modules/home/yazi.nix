{ lib, pkgs, ... }:
let
  yazi-plugins-aminur = pkgs.fetchgit {
    url = "https://github.com/AminurAlam/yazi-plugins";
    rev = "ce325af662cbdd438194c68b6d69a3ff59c1b305";
    sparseCheckout = [ 
      "preview-epub.yazi"
      "preview-audio.yazi"
    ];
    hash = "sha256-kcor4t+N+99rbE217QUmnvbnE7dTOR/gfzthi9AbcnA=";
  };
in
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
      plugin = {
        prepend_previewers = [
          { mime = ""; run = "preview-epub"; }
          { mime = "audio/mpegurl"; run = "code"; } # ignore .m3u files
          { mime = "audio/*"; run = "preview-audio"; }
          { url = "*.md"; run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"''; }
        ];
        prepend_preloaders = [
          { mime = ""; run = "preview-epub"; }
          { mime = "audio/mpegurl"; run = "code"; } # ignore .m3u files
          { mime = "audio/*"; run = "preview-audio"; }
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
      preview-epub = {
        package = "${yazi-plugins-aminur}/preview-epub.yazi";
      };
      preview-audio = {
        package = "${yazi-plugins-aminur}/preview-audio.yazi";
      };
      piper = {
        package = pkgs.yaziPlugins.piper;
      };
    };
  };

  home.packages = with pkgs; [
    ueberzugpp
    poppler-utils
    exiftool
    epub-thumbnailer
    glow
  ];
}
