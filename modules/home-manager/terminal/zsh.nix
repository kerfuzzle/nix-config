{ pkgs, ... }: {
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		syntaxHighlighting.enable = true;
		
		shellAliases = with pkgs; {
			ls = "${pkgs.eza}/bin/eza --icons";
			tree = "${pkgs.eza}/bin/eza --tree --icons";
			r = "${pkgs.nh}/bin/nh os switch";
			hyrel = "hyprctl reload";
			battery = "cat /sys/class/power_supply/BAT0/capacity";
		};	
	};
}
