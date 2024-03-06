{
  self,
  lib,
  withSystem,
  ...
}: let
  inherit (self) inputs;

  # mkNixosIso and mkNixosSystem are builders for assembling a nixos system
  inherit (lib) concatLists mkNixosIso mkNixosSystem;

  ## flake inputs ##
  hm = inputs.home-manager.nixosModules.home-manager; # home-manager nixos module

  # serializing the modulePath to a variable
  # this is incase the modulePath changes depth (i.e modules becomes nixos/modules)
  modulePath = ../modules;

  coreModules = modulePath + /core; # the path where common modules reside
  # extraModules = modulePath + /extra; # the path where extra modules reside
  options = modulePath + /options; # the module that provides the options for my system configuration

  # common modules
  # to be shared across all systems without exception
  common = coreModules + /common; # the self-proclaimed sane defaults for all my systems
  profiles = coreModules + /profiles; # force defaults based on selected profile

  # roles
  workstation = coreModules + /roles/workstation; # for devices that are of workstation type - any device that is for daily use
  # server = coreModules + /roles/server; # for devices that are of the server type - provides online services
  # laptop = coreModules + /roles/laptop; # for devices that are of the laptop type - provides power optimizations
  # headless = coreModules + /roles/headless; # for devices that are of the headless type - provides no GUI
  # iso = coreModules + /roles/iso; # for providing a uniform iso configuration for live systems - only the build setup

  # extra modules - optional but likely critical to a successful build
  # sharedModules = extraModules + /shared; # the path where shared modules reside

  # home-manager #
  homesDir = ../homes; # home-manager configurations for hosts that need home-manager
  homes = [hm homesDir]; # combine hm flake input and the home module to be imported together

  # a list of shared modules that ALL systems need
  shared = [
    common # the "sane" default shared across systems
    options # provide options for defined modules across the system
    # sharedModules # consume my flake's own nixosModules
    profiles # profiles program overrides per-host
  ];

  # extraSpecialArgs that all hosts need
  # sharedArgs = {inherit inputs self lib;};
in {
  # My main desktop 
  sol = mkNixosSystem {
    inherit withSystem;
    hostname = "sol";
    system = "x86_64-linux";
    modules =
      [
        ./sol
        workstation
      ]
      ++ concatLists [shared homes];
    specialArgs = {inherit lib;};
  };
}
