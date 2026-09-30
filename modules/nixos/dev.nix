# The system half of the dev role. The daemon and group membership have to be
# set at the system level; the tools themselves are user packages and live in
# modules/home/dev.nix.
{ config, lib, ... }:

let
  cfg = config.maxdeviant;
in
{
  config = lib.mkIf cfg.roles.dev {
    # For projects that run Postgres, Redis, etc. under Docker Compose. Don't
    # start the daemon at boot: docker.socket is still enabled, so the first
    # `docker` command starts it on demand.
    virtualisation.docker = {
      enable = true;
      enableOnBoot = false;
    };

    # Talking to the daemon without sudo. Note that the docker group is
    # root-equivalent.
    users.users.${cfg.identity.username}.extraGroups = [ "docker" ];
  };
}
