let 
	resample-quality = {
		"10-hires" = {
			"stream.properties" = {
				"resample.quality" = 14;
			};
		};
	};
in {
	security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

		extraConfig = {
			pipewire = {
				"10-hires" = {
					"context.properties" = {
						"default.clock.allowed-rates" = [ 44100 48000 64000 88200 96000 128000 176400 192000 256000 352800 384000 512000 705600 768000 ];
					};
				};

				"10-dawn-pro" = {
					"device.rules" = [
						{
							"matches" = [
								{
									"device.product.name" = "MOONDROP Dawn Pro";
								}
							];
							"actions" = {
								"update-props" = {
									"device.form-factor" = "headphone";
								};
							};
						}
					];
				};
			};

			client = resample-quality;
			pipewire-pulse = resample-quality;
		};
  };
}
