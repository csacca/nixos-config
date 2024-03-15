{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.types) package;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.modules.usrEnv.screenlock;
  pkg =
    if cfg.gtklock.enable then
      pkgs.gtklock
    else if cfg.swaylock.enable then
      pkgs.swaylock-effects
    else if cfg.hyprlock.enable then
      pkgs.hyprland
    else
      null;
in {
  options.modules.usrEnv.screenlock = {
    gtklock.enable = mkEnableOption "gtklock screenlocker";
    swaylock.enable = mkEnableOption "swaylock screenlocker";
    hyprlock.enable = mkEnableOption "hyprlock screenlocker";

    package = mkOption {
      type = package;
      default = pkg;
      readOnly = true;
      description = "The screenlocker package";
    };
  };
}
