{
  inputs,
  inputs',
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf primaryMonitor;
  inherit (osConfig) modules;
  inherit (osConfig.modules.style.colorScheme) colors;

  env = modules.usrEnv;

  font_family = "Lexend";
in {
  imports = [inputs.hyprlock.homeManagerModules.default];

  config = mkIf env.screenlock.hyprlock.enable {
    programs.hyprlock = {
      enable = true;

      general = {
        disable_loading_bar = true;
        hide_cursor = false;
        no_fade_in = true;
      };

      backgrounds = [
        {
          monitor = "";
          # path = "${theme.wallpaper}";
          color = "rgb(${colors.base01})";
        }
      ];

      input-fields = [
      {
        monitor = primaryMonitor osConfig;

        size = {
          width = 300;
          height = 50;
        };

        outline_thickness = 2;

        outer_color = "rgb(${colors.base0D})";
        inner_color = "rgb(${colors.base00})";
        font_color = "rgb(${colors.base05})";

        fade_on_empty = false;
        placeholder_text = ''<span font_family="${font_family}" foreground="##${colors.base05}">Password...</span>'';

        dots_spacing = 0.3;
        dots_center = true;
      }
    ];

    labels = [
      {
        monitor = "";
        text = "$TIME";
        inherit font_family;
        font_size = 64;
        color = "rgba(${colors.base0D}bf)";

        position = {
          x = 0;
          y = 80;
        };

        valign = "center";
        halign = "center";
      }
    ];
    };
  };
}
