{
  programs.ssh = {
    enable = true;

    # Home Manager's legacy defaults are slated for removal; opt out now and
    # declare anything we actually want explicitly.
    enableDefaultConfig = false;

    settings = {
      "github.com" = {
        AddKeysToAgent = "yes";
        IdentityFile = "~/.ssh/github_ed25519";
      };

      "tangled.org" = {
        HostName = "tangled.org";
        User = "git";
        IdentityFile = "~/.ssh/tangled_ed25519";
        IdentitiesOnly = true;
        AddressFamily = "inet";
      };
    };
  };
}
