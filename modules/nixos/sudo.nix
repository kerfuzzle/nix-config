{
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    # Never display the "We trust you have ..." lecture
    # mostly because of impermanence
    extraConfig = ''
      			Defaults lecture = never
      		'';
  };
}
