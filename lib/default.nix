{inputs}: let
  inherit (inputs.nixpkgs) lib;
  inherit (lib) foldl recursiveUpdate;
  # inherit (import ./core.nix {inherit lib;}) mergeRecursively;

  # helpful utility functions used around the system
  builders = import ./builders.nix {inherit inputs lib;}; # system builders
  hardware = import ./hardware.nix; # hardware capability checks
  validators = import ./validators.nix {inherit lib;}; # validate system conditions

  importedLibs = [builders hardware validators];

  # recursively merges two attribute sets
  # it is used to convert the importedLibs list into an attrset
  # there is probably a better way to do it, more cleanly - but I wouldn't know
  mergeRecursively = lhs: rhs: recursiveUpdate lhs rhs;

in
  # extend nixpkgs lib
  lib.extend (_: _: foldl mergeRecursively {} importedLibs)
