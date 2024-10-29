{ inputs, ...}: {
	environment.systemPackages = [
		inputs.rip2.packages."x86_64-linux".default
	];
}
