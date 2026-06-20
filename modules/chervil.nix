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
      START_CHARGE_THRESH_BAT0 = 0;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      intel-media-driver
      intel-vaapi-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };
}
