{pkgs, ...}: {
  config.modules.system = {
    mainUser = "csacca";
    fs = ["btrfs" "ext4" "vfat" "ntfs"];
    autoLogin = false;

    boot = {
      loader = "systemd-boot";
      secureBoot = false;
      kernel = pkgs.linuxPackages_xanmod_latest;
      enableKernelTweaks = true;
      initrd.enableTweaks = true;
      loadRecommendedModules = true;
      tmpOnTmpfs = true;
      # plymouth = {
      #   enable = true;
      #   withThemes = false;
      # };
    };

    encryption = {
      enable = true;
      device = "enc";
    };

    video.enable = true;
    sound.enable = true;
    bluetooth.enable = false;
    printing.enable = false;

    networking = {
      optimizeTcp = true;
    };
  };
}
