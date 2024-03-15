{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  inherit (osConfig) meta;

  sys = osConfig.modules.system;
  prg = sys.programs;
in {
  config = mkIf (prg.gui.enable && (sys.video.enable && meta.isWayland)) {
    home.packages = with pkgs; [
      wlogout
      swappy
    ];
  };
}
