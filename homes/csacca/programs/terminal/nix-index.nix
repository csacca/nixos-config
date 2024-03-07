{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.nix-index-db.hmModules.nix-index];

  config = {
    home.sessionVariables = {
      # auto-run programs using nix-index-database
      NIX_AUTO_RUN = "1";
    };

    programs = {
      nix-index-database.comma.enable = true;

      # disable command-not-found
      command-not-found.enable = lib.mkForce false;

      nix-index = {
        enable = true;

        # link nix-inde database to ~/.cache/nix-index
        symlinkToCacheHome = true;
      };
    };
  };
}
