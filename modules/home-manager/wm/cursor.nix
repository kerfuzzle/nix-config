{ pkgs, ... }: {
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.phinger-cursors;
    name = "phinger-cursors-light";
    size = 4;
  };
}
