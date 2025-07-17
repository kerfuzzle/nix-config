{
  services.asusd = {
    enable = true;
    asusdConfig.text = ''
      			(
            	bat_charge_limit: 80,
            )
    '';
  };
}
