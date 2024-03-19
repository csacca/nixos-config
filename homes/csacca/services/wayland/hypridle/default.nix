{
  lib,
  pkgs,
  config,
  osConfig,
  inputs,
  inputs',
  ...
}: let
  inherit (lib) getExe mkIf;

  systemctl = "${pkgs.systemd}/bin/systemctl";
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all | ${pkgs.ripgrep}/bin/rg running
    # only suspend if audio isn't running
    if [ $? == 1 ]; then
      ${systemctl} suspend
    fi
  '';

  env = osConfig.modules.usrEnv;
in {
  imports = [inputs.hypridle.homeManagerModules.default];

  config = mkIf env.desktops.hyprland.enable {
    services.hypridle = {
      enable = true;
      beforeSleepCmd = "${pkgs.systemd}/bin/loginctl lock-session";
      lockCmd = getExe config.programs.hyprlock.package;

      listeners = [
        {
          timeout = 300;
          onTimeout = "${getExe config.programs.hyprlock.package}";
        }
        {
          timeout = 380;
          onTimeout = "${inputs'.hyprland.packages.hyprland}/bin/hyprctl dispatch dpms off";
          onResume = "${inputs'.hyprland.packages.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 1800;
          onTimeout = suspendScript.outPath;
        }
      ];
    };
  };
}
