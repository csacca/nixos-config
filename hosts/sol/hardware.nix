{
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/60f0d725-c098-44a1-b016-ab3c0a44606e";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
