{
  # https://github.com/csacca/nixos-config
  description = "My NixOS configuration";

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} ({withSystem, ...}: {
      # systems for which the `perSystem` attributes will be built
      systems = [
        "x86_64-linux"
      ];

      imports = [
        # parts of the flake
        ./flake/args.nix # args that are passsed to the flake, moved away from the main file
      ];

      flake = let
        # extended nixpkgs library, contains my custom functions
        lib = import ./lib {inherit inputs;};
      in {
        # entry-point for nixos configurations
        nixosConfigurations = import ./hosts {inherit nixpkgs self lib withSystem;};
      };

      perSystem = {
        inputs',
        config,
        pkgs,
        ...
      }: {
        # set pkgs to the legacyPackages inherited from config instead of the one
        # initiated by flake-parts
        # imports = [{_module.args.pkgs = config.legacyPackages;}];

        # provide the formatter for nix fmt
        formatter = pkgs.alejandra;

        devShells.default = pkgs.mkShell {
          name = "nixos-config";
          meta.description = "The default development shell for my NixOS configuration";

          # shellHook = ''
          #   ${config.pre-commit.installationScript}
          # '';

          # tell direnv to shut up
          DIRENV_LOG_FORMAT = "";

          # packages available in the dev shell
          packages = with pkgs; [
            nil # nix ls
            alejandra # nix formatter
            git # flakes require git, and so do I
            statix # lints and suggestions
            deadnix # clean up unused nix code
            (pkgs.writeShellApplication {
              name = "update";
              text = ''
                nix flake update && git commit flake.lock -m "flake: bump inputs"
              '';
            })
          ];

          inputsFrom = [];
        };
      };
    });

  inputs = {
    # We build against nixos unstable, because stable takes way too long to get things into
    # more versions with or without pinned branches can be added if deemed necessary
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # sometimes nixpkgs breaks something I need, pin a working commit when that occurs
    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/b610c60e23e0583cdc1997c54badfd32592d3d3e";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Powered by
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Nix wrapper for building and testing my system
    nh = {
      url = "github:viperML/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-index database
    nix-index-db = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
