{
  programs.git = {
    enable = true;
    userName = "kerfuzzle";
    userEmail = "58907164+kerfuzzle@users.noreply.github.com";

    includes = [
      {
        condition = "gitdir:~/documents/githubWork/";
        path = "~/documents/githubWork/.gitconfig";
      }
    ];
  };
}
