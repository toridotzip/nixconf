{ pkgs, ... }:

{
  services.paperless = {
    enable = true;
    dataDir = "/var/lib/paperless";
    mediaDir = "/mnt/media/documents/media";
    consumptionDir = "/mnt/media/documents/consume";
    consumptionDirIsPublic = true;
    address = "0.0.0.0";
    port = 28981;
    settings = {
      PAPERLESS_ADMIN_USER = "etcvi";
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_SKIP_ARCHIVE_FILE = "with_text";
    };
  };
}
