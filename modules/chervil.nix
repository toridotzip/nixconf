{ pkgs, ... }:

{
    services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
  };

  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

#  systemd.user.services.lowbat-notify = {
#    Unit.Description = "Low Battery Notification";
#    Service = {
#      Type = "simple";
#      ExecStart = "${pkgs.bash}/bin/bash -c 'while true; do capacity=$(cat /sys/class/power_supply/BAT0/capacity); status=$(cat /sys/class/power_supply/BAT0/status); if [ \"$status\" = \"Discharging\" ]; then if [ $capacity -le 10 ]; then ${pkgs.libnotify}/bin/notify-send -u critical \"Very Low Battery\" \"$capacity%\"; elif [ $capacity -le 20 ]; then ${pkgs.libnotify}/bin/notify-send -u normal \"Low Battery\" \"$capacity%\"; fi; fi; sleep 300; done'";
#    };
#    Install.WantedBy = [ "graphical-session.target" ];
#  };

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 Elan TrackPoint";
    sensitivity = 50;
    speed = 10;
    inertia = 20;
    emulateWheel = true;
  };
}
