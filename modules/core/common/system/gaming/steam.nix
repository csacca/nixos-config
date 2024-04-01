{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  prg = config.modules.system.programs;
in {
  config = mkIf prg.gaming.enable {
    nixpkgs = {
      config = {
        allowUnfreePredicate = pkg:
          builtins.elem (lib.getName pkg) [
            "steam"
            "steam-original"
            "steam-runtime"
          ];
      };

      #   overlays = [
      #     (_: prev: {
      #       steam = prev.steam.override ({extraPkgs ? _: [], ...}: {
      #         extraPkgs = pkgs':
      #           (extraPkgs pkgs')
      #           # Add missing dependencies
      #           ++ (with pkgs'; [
      #             # Generic dependencies
      #             libgdiplus
      #             keyutils
      #             libkrb5
      #             libpng
      #             libpulseaudio
      #             libvorbis
      #             stdenv.cc.cc.lib
      #             xorg.libXcursor
      #             xorg.libXi
      #             xorg.libXinerama
      #             xorg.libXScrnSaver
      #             at-spi2-atk
      #             fmodex
      #             gtk3
      #             gtk3-x11
      #             harfbuzz
      #             icu
      #             glxinfo
      #             inetutils
      #             libthai
      #             mono5
      #             pango
      #             strace
      #             zlib

      #             # for Titanfall 2 Northstar launcher
      #             libunwind
      #           ]);
      #       });
      #     })
      #   ];
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };

    programs.steam = {
      # Enable steam
      enable = true;

      # package = pkgs.steam.override {
      #   extraPkgs = pkgs:
      #     with pkgs; [
      #       keyutils
      #       libkrb5
      #       libpng
      #       libpulseaudio
      #       libvorbis
      #       stdenv.cc.cc.lib
      #       xorg.libXcursor
      #       xorg.libXi
      #       xorg.libXinerama
      #       xorg.libXScrnSaver
      #     ];
      # };

      # # enable gamescope
      gamescopeSession = {
        enable = true;
        args = [
          "-W 3840"
          "-H 2160"
          "--rt"
        ];
      };

      # Open ports in the firewall for Steam Remote Play
      # remotePlay.openFirewall = true;

      # Open ports in the firewall for Source Dedicated Server
      # dedicatedServer.openFirewall = false;

      # Compatibility tools to install
      # For the accepted format (and the reason behind)
      # the "compattool" attribute, see:
      # <https://github.com/NixOS/nixpkgs/pull/296009>
      # extraCompatPackages = [
      #   pkgs.proton-ge-bin.steamcompattool
      # ];
    };
  };
}
