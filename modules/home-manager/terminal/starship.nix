{ lib, ... }:
{
  programs.starship =
    let
      formatString = lib.strings.concatStrings (
        map (s: "\$${s}") [
          "username"
          "hostname"
          "directory"
          "shell"
          "nix_shell"
          "git_branch"
          "git_commit"
          "git_state"
          "git_status"
          "cmd_duration"
        ]
      );
    in
    {
      enable = true;
      enableZshIntegration = true;

      settings = {
        add_newline = false;
        format = "${formatString}\n$character";

        username = {
          disabled = false;
          format = "[$user](bold yellow)";
        };

        hostname = {
          ssh_only = false;
          disabled = false;
          format = "@[$hostname](bold blue) ";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
        };
      };
    };
}
