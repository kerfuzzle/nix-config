{
  programs.zathura = {
    enable = true;
    options = {
      # Open document zoomed to page width
      adjust-open = "width";
      # Make shift-click trigger SyncTeX
      synctex-edit-modifier = "shift";
    };
  };
}
