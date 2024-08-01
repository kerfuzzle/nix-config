{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      character = {
        success_symbol = "[➜](bold green)";
      };

      hostname = {
        ssh_only = false;
        disabled = false;
      };
    };
  };
}
