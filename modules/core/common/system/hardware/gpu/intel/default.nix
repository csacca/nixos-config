{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;

  # let me play youtube videos without h.264, please and thank you
  # vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};

  intel-vaapi-driver = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
in {
  config = mkIf (builtins.elem dev.gpu.type ["intel" "hybrid-intel"]) {
    # enable the i915 kernel module
    boot.initrd.kernelModules = ["i915"];

    # # i915 kernel params
    # # FIXME: this is really only for 9 <= gen < 12 intel cpus
    # boot.kernelParams = [
    #   "i915.enable_guc=2"
    #   "i915.enable_psr=0"
    #   "i915.enable_fbc=1"
    #   "video=SVIDEO-1:d"
    # ];

    # better performance than the actual Intel driver
    services.xserver.videoDrivers = ["modesetting"];

    # OpenCL support and VAAPI
    hardware.opengl = {
      extraPackages = with pkgs; [
        intel-compute-runtime # OpenCL library for iGPU

        # video encoding/decoding hardware acceleration
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        libva-vdpau-driver
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        # intel-compute-runtime # FIXME does not build due to unsupported system
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    environment.variables = mkIf (config.hardware.opengl.enable && dev.gpu != "hybrid-nv") {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
