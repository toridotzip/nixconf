{ ... }:

{
  services.calibre-server = {
    enable = true;
    libraries = [ "/mnt/media/books/calibre" ];
    port = 8080;
    user = "etcvi";
    group = "users";
    extraFlags = [ ];
  };

  systemd.services.calibre-library-restart = {
    description = "calibre-server restart on library change";
    serviceConfig.Type = "oneshot";
    script = ''
      sleep 300
      systemctl restart calibre-server.service
    '';
  };

  systemd.paths.calibre-library-watch = {
    description = "calibre library folder watcher";
    wantedBy = [ "multi-user.target" ];
    pathConfig = {
      PathModified = "/mnt/media/books/calibre/";
      Unit = "calibre-library-restart.service";
    };
  };
}
