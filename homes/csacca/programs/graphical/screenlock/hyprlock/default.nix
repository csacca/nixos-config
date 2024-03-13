{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  inherit (osConfig.modules.style.colorScheme) colors;

  env = modules.usrEnv;
in {
  config = mkIf env.screenlock.hyprlock.enable {

  };
}