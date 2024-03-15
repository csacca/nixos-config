{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config) modules;

  env = modules.usrEnv;
in {
  config = mkIf (env.desktop != "gnome") {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = false;
      displayManager.lightdm.enable = false;
    };
  };
}
