{ config, ... }:

{
  age.secrets.mailbox-pass = {
    file = ../../secrets/mailbox-pass.age;
  };

  accounts.email = {
    maildirBasePath = "${config.home.homeDirectory}/Mail";

    accounts = {
      mailbox = {
        primary = true;
        address = "mail@tori.zip";
        realName = "Viktoria Köhler";
        userName = "mail@tori.zip";
        passwordCommand = "cat ${config.age.secrets.mailbox-pass.path}";

        imap = {
          host = "imap.mailbox.org";
          port = 993;
          tls.enable = true;
        };
        smtp = {
          host = "smtp.mailbox.org";
          port = 465;
          tls.enable = true; 
        };

        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "both";
          patterns = [ "*" ];
        };
        msmtp.enable = true;
        neomutt.enable = true;
      };
    };
  };
  
  programs = {
    mbsync.enable = true;
    msmtp.enable = true;

    neomutt = {
      enable = true;
      vimKeys = true;

      sidebar = {
        enable = true;
        width = 25;
      };

      extraConfig = ''
        set sort = threads
        set sort_aux = reverse-last-date-received
      '';
    };
  };
}
