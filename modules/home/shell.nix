{
  # The NixOS side also sets programs.fish.enable -- there it registers fish in
  # /etc/shells so it can be a login shell, here it writes the configuration.
  programs.fish = {
    enable = true;

    shellAliases = {
      gs = "git status";
      gc = "git commit";
      gca = "git add -A; and git commit";
      gd = "git diff";
      gl = "git log";
      gp = "git pull";
      goops = "git add -A; and git reset --hard HEAD";
    };

    functions = {
      gll = "git log --graph --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'";

      glll = "git log --graph --stat --date=short --pretty=format:'%Cgreen%h %Cblue%cd (%cr) %Cred%an%C(yellow)%d%Creset: %s'";

      gopr = {
        argumentNames = [ "pr_number" ];
        body = ''
          if not string match -rq "[0-9]+" $pr_number
            echo "PR number is required."
            return 1
          end

          git fetch origin pull/$pr_number/head:pr/$pr_number
          git checkout pr/$pr_number
        '';
      };
    };
  };

  programs.bash.enable = true;
}
