_: {
  # variables that I want to set globally on all systems

  environment.variables = {
    FLAKE = "/home/csacca/Documents/nixos-config";
    SSH_AUTH_SOCK = "/run/user/\${UID}/keyring/ssh";

    # editors
    EDITOR = "nano";
    VISUAL = "nano";
    SUDO_EDITOR = "nano";

    # pager stuff
    SYSTEMD_PAGERSECURE = "true";
    PAGER = "less -FR";
    # MANPAGER = "less -FR";
  };
}
