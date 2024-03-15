{
  config,
  lib,
  inputs',
  ...
}: let
  inherit (lib) mkIf;

  sys = config.modules.system;
  env = config.modules.usrEnv;
  meta = config.meta;
in {
  # disables Nixpkgs Hyprland module to avoid conflicts
  disabledModules = ["programs/hyprland.nix"];

  config = mkIf (sys.video.enable && (env.desktop == "Hyprland" && meta.isWayland)) {
    services.xserver.displayManager.sessionPackages = [inputs'.hyprland.packages.default];

    xdg.portal = {
      extraPortals = [
        inputs'.xdg-portal-hyprland.packages.xdg-desktop-portal-hyprland
      ];
    };
  };
}
