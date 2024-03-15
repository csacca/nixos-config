{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.modules.usrEnv;
  sys = config.modules.system;
in {
  imports = [
    # ./launchers.nix
    ./lockers.nix
  ];

  options.modules.usrEnv = {
    desktop = mkOption {
      type = types.enum ["none" "hyprland" "gnome"];
      default = "none";
      description = ''
        The desktop environment to be used.
      '';
    };

    desktops = {
      hyprland.enable = mkOption {
        type = types.bool;
        default = cfg.desktop == "hyprland";
        description = ''
          Whether to enable Hyprland wayland compositor.

          Will be enabled automatically when `modules.usrEnv.desktop` is set to "hyprland".

        '';
      };

      gnome.enable = mkOption {
        type = types.bool;
        default = cfg.desktop == "gnome";
        description = ''
          Whether to enable Gnome desktop manager.

          Will be enabled automatically when `modules.usrEnv.desktop` is set to "gnome".
        '';
      };
    };

    useHomeManager = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable the usage of home-manager for user home management. Maps the list
        of users to their home directories inside the `homes/` directory in the repository
        root.

        Username via `modules.system.mainUser` must be set if this option is enabled.
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.useHomeManager -> sys.mainUser != null;
        message = "usrEnv.mainUser must be set while useHomeManager is enabled";
      }
    ];
  };
}
