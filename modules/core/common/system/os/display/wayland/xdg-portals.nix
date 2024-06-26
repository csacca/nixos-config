{
  config,
  lib,
  pkgs,
  ...
}: let
  sys = config.modules.system;
  env = config.modules.usrEnv;
  meta = config.meta;
  inherit (lib) mkForce mkIf;
in {
  config = mkIf (sys.video.enable && env.desktop != "gnome") {
    xdg.portal = {
      enable = true;

      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];

      config = {
        common = let
          portal =
            if env.desktop == "Hyprland"
            then "hyprland"
            else "wlr";
        in {
          # for flameshot to work
          # https://github.com/flameshot-org/flameshot/issues/3363#issuecomment-1753771427
          default = "gtk";
          "org.freedesktop.impl.portal.Screencast" = "${portal}";
          "org.freedesktop.impl.portal.Screenshot" = "${portal}";
        };
      };

      # xdg-desktop-wlr (this section) is no longer needed, xdg-desktop-portal-hyprland
      # will (and should) override this one
      # however in case I run a different compositor on a Wayland host, it can be enabled
      wlr = {
        enable = mkForce (meta.isWayland && env.desktop != "hyprland");
        settings = {
          screencast = {
            max_fps = 60;
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          };
        };
      };
    };
  };
}
