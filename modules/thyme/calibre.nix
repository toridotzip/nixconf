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
}
