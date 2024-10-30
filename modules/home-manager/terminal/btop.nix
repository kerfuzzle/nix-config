{ pkgs, ... }: let 
	btop-with-nvidia = pkgs.btop.override { cudaSupport = true; };
in {
	programs.btop = {
		enable = true;
		package = btop-with-nvidia;
		settings = {
			clock_format = "%X /uptime";
			shown_boxes = "cpu gpu0 mem net proc";
			cpu_single_graph = true;
			gpu_mirror_graph = false;
		};
	};
}
	
