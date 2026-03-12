{ pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mysql;
  };

  environment.systemPackages = with pkgs; [
    mycli
    gh
    nodejs
    pnpm
    mysql-workbench
  ];

  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [ "9.9.9.9" ];
      };
    };
  };
}
