{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  dev = config.modules.device;
in {
  config = mkIf (builtins.elem dev.cpu.type ["intel" "vm-intel"]) {
    hardware.cpu.intel.updateMicrocode = true;
    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = [];
    };

    environment.systemPackages = with pkgs; [intel-gpu-tools];
  };
}
