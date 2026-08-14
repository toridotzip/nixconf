{ ... }:

{
  services.calibre-server = {
    enable = true;
    libraries = [ "/mnt/media/books/calibre-library-thyme/" ];
    port = 8080;
    user = "etcvi";
    group = "users";
    extraFlags = [ ];
  };
}
