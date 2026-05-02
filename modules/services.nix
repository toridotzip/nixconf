{ config, pkgs, ...}:

{
  # Warn before shutdown if rebuild pending
  systemd.services.nixos-test-warning = {
    before = [ "shutdown.target" "reboot.target" ];
    conflicts = [ "shutdown.target" "reboot.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "check-nixos-test" ''
        flag="/run/user/1001/nixos-test-pending"
        if [ -f "$flag" ]; then
          echo "WARNING: You ran 'rebuild test' but not 'rebuild switch'!"
          echo "Changes will be lost on reboot. Press Ctrl+C to cancel shutdown."
          sleep 10
        fi
      '';
    };

    wantedBy = [ "shutdown.target" "reboot.target" ];
  };
}
