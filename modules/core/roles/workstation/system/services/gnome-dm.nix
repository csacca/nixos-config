{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  dev = modules.device;
  env = modules.usrEnv;
  # sys = modules.system;

  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (env.desktop == "gnome" && (builtins.elem dev.type acceptedTypes)) {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
