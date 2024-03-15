{
  config,
  pkgs,
  ...
}: let
  sys = config.modules.system;
in {
  # 1password for password management
  programs._1password = {
    enable = true;
  };
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [sys.mainUser];
    package = pkgs._1password-gui-beta; # or pkgs._1password-gui
  };
}
