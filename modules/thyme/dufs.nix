{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dufs
  ];

  systemd.services.dufs = {
    description = "Dufs file server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.dufs}/bin/dufs --bind 0.0.0.0 --port 5000 --allow-upload --auth 'etcvi:$6$EKWBoY1G3B77LBzf$a2/4tlCCRG32defWJzVR2A6drKMggukbvCW2lQY4k98rvoQKoc8SgaL90jfdDUwV.ET5Od/C8cWVvO4K5CktP/@/:rw' /mnt/media/dufs";
      Restart = "always";
      User = "dufs";
      Group = "dufs";

      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
    };
  };

  users.users.dufs = {
    isSystemUser = true;
    group = "dufs";
  };

  users.groups.dufs = {};
}
