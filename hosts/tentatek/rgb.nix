{ pkgs, ... }: let

	openrgb-pipeline = pkgs.openrgb-with-all-plugins.overrideAttrs {
		version = "pipeline";
		src = pkgs.fetchFromGitLab {
			owner = "CalcProgrammer1";
			repo = "OpenRGB";
			rev = "8565a3ddee581f319f63a7b506111fbb6e4d9f0c";
			sha256 = "sha256-pO6sp3mA8x2cQmB62SWUaAaQvyJOUG5KTMHLAYDG8ck=";
		};

		postPatch = ''
   		patchShebangs scripts/build-udev-rules.sh
    	substituteInPlace scripts/build-udev-rules.sh \
      	--replace /usr/bin/env "${lib.getExe' pkgs.coreutils "chmod"}"
		'';
	};
in {
	environment.systemPackages = [
		openrgb-pipeline
	];

	services.hardware.openrgb = {
		enable = true;
		motherboard = "amd";
		package = openrgb-pipeline;
	};
}
