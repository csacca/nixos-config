{
  imports = [
    ./boot # boot and bootloader configurations
    # ./display # display protocol (wayland/xorg)
    ./environment # environment configuration
    ./fs # filesystem support options
    ./misc # things that don't fit anywhere else
    ./networking # network configuration & tcp optimizations
    ./programs # general programs
    ./services # gemeral services
    ./users # per user configurations
  ];
}
