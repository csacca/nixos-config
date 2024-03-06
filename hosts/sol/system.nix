{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [
      firefox
      vscode
      nil
      alejandra
      git
      wget
      glow
      statix
      deadnix
    ];
  };
}
