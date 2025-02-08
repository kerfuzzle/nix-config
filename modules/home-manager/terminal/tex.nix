{ pkgs, ... }: 
let tex = (pkgs.texlive.combine {
		inherit (pkgs.texlive) scheme-basic
		latexmk;
	});
in {
	home.packages = [ tex ];
}
