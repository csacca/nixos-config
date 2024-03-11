{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf concatStringsSep getExe;

  dev = config.modules.device;
  env = config.modules.usrEnv;
  sys = config.modules.system;
  sessionData = config.services.xserver.displayManager.sessionData.desktops;
  sessionPath = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];
  acceptedTypes = ["desktop" "laptop" "hybrid" "lite"];
in {
  config = mkIf (env.desktop != "gnome" && (builtins.elem dev.type acceptedTypes)) {
    # unlock GPG keyring on login
    security.pam.services = {
      login = {
        enableGnomeKeyring = true;
        gnupg = {
          enable = true;
          noAutostart = true;
          storeOnly = true;
        };
      };

      greetd = {
        gnupg.enable = true;
        enableGnomeKeyring = true;
      };
    };

    services = {
      xserver.displayManager.session = [
        {
          manage = "desktop";
          name = "hyprland";
          start = ''
            Hyprland
          '';
        }
      ];

      greetd = {
        enable = true;
        vt = 2;
        restart = !sys.autoLogin;
        settings = {
          # pick up desktop variant (i.e Hyprland) and username from usrEnv
          # this option is usually defined in host/<hostname>/system.nix
          initial_session = mkIf sys.autoLogin {
            command = "${env.desktop}";
            user = "${sys.mainUser}";
          };

          default_session =
            if (!sys.autoLogin)
            then {
              command = concatStringsSep " " [
                (getExe pkgs.greetd.tuigreet)
                "--time"
                "--remember"
                "--remember-user-session"
                "--asterisks"
                "--sessions '${sessionPath}'"
              ];
              user = "greeter";
            }
            else {
              command = "${env.desktop}";
              user = "${sys.mainUser}";
            };
        };
      };

      gnome = {
        glib-networking.enable = true;
        gnome-keyring.enable = true;
      };

      logind = {
        lidSwitch = "suspend-then-hibernate";
        lidSwitchExternalPower = "lock";
        extraConfig = ''
          HandlePowerKey=suspend-then-hibernate
          HibernateDelaySec=3600
        '';
      };
    };
  };
}
