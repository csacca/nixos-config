{
  config,
  pkgs,
  ...
}: let
  inherit (config) meta;
in {
  # determine which version of wine to be used
  # then add it to systemPackages
  environment.systemPackages = with pkgs; let
    winePackage =
      if meta.isWayland
      then wineWowPackages.waylandFull
      else wineWowPackages.stableFull;
  in [winePackage];
}
