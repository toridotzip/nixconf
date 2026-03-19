{ pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
  };

  environment.systemPackages = with pkgs; [
    duckdb
    mycli
    gh
    nodejs
    pnpm
    mysql-workbench
    dbeaver-bin
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
