{ pkgs, lib, ... }: {
  home.sessionVariables."GTK_IM_MODULE" = lib.mkForce "";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-mozc-ut
      ];

      settings = {
        inputMethod = {
          "GroupOrder"."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "gb";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-gb";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
          };
        };

        globalOptions = {
          Behavior = {
            ShareInputState = "No";
            ShowInputMethodInfomation = true;
            # Lowercase attirubute name is intentional below
            showInputMethodInformationWhenFocusIn = true;
            CompactInputMethodInformation = false;
            ShowPreeditForPassword = false;
          };
        };
      };
    };
  };
}
