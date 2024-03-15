{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    services = {
      # enable GVfs, a userspace virtual filesystem.
      gvfs.enable = true;

      # thumbnail support on thunar
      tumbler.enable = true;

      # storage daemon required for udiskie auto-mount
      udisks2.enable = !config.boot.isContainer;

      dbus = {
        enable = true;
        packages = with pkgs; [dconf gcr udisks2];

        # Use the faster dbus-broker instead of the classic dbus-daemon
        # this setting is experimental, but after testing I've come to realise it broke nothing
        implementation = "broker";
      };

      # disable chrony in favor if systemd-timesyncd
      timesyncd.enable = lib.mkDefault true;
      chrony.enable = lib.mkDefault false;

      # https://dataswamp.org/~solene/2022-09-28-earlyoom.html
      # avoid the linux kernel from locking itself when we're putting too much strain on the memory
      # this helps avoid having to shut down forcefully when we OOM
      earlyoom = {
        enable = true;
        enableNotifications = true; # annoying, but we want to know what's killed
        freeSwapThreshold = 2;
        freeMemThreshold = 2;
        extraArgs = [
          "-g"
          "--avoid 'Hyprland|soffice|soffice.bin|firefox|thunderbird)$'" # things we want to not kill
          "--prefer '^(electron|.*.exe)$'" # I wish we could kill electron permanently
        ];

        # we should ideally write the logs into a designated log file; or even better, to the journal
        # for now we can hope this echo sends the log to somewhere we can observe later
        killHook = pkgs.writeShellScript "earlyoom-kill-hook" ''
          echo "Process $EARLYOOM_NAME ($EARLYOOM_PID) was killed"
        '';
      };
    };

    systemd = let
      extraConfig = ''
        DefaultTimeoutStartSec=15s
        DefaultTimeoutStopSec=15s
        DefaultTimeoutAbortSec=15s
        DefaultDeviceTimeoutSec=15s
      '';
    in {
      inherit extraConfig;
      user = {inherit extraConfig;};
      services = {
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
        "getty@tty7".enable = false;
        "autovt@tty7".enable = false;
        "kmsconvt@tty1".enable = false;
        "kmsconvt@tty7".enable = false;
      };
    };
  };
}
