{
  config = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/f2c8ca90-c080-4ab5-af9f-cb66ce260738";
        fsType = "btrfs";
        options = ["subvol=root" "compress=zstd" "noatime"];
      };

      "/nix" = {
        device = "/dev/disk/by-uuid/f2c8ca90-c080-4ab5-af9f-cb66ce260738";
        fsType = "btrfs";
        options = ["subvol=nix" "compress=zstd" "noatime"];
      };

      "/persist" = {
        device = "/dev/disk/by-uuid/f2c8ca90-c080-4ab5-af9f-cb66ce260738";
        fsType = "btrfs";
        options = ["subvol=persist" "compress=zstd" "noatime"];
        neededForBoot = true;
      };

      "/var/log" = {
        device = "/dev/disk/by-uuid/f2c8ca90-c080-4ab5-af9f-cb66ce260738";
        fsType = "btrfs";
        options = ["subvol=log" "compress=zstd" "noatime"];
        neededForBoot = true;
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/1B3A-071B";
        fsType = "vfat";
      };
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/eceae94b-9c2a-4807-8c38-c7463e2a84d3";}
    ];
  };
}
