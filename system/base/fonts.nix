{pkgs, ...}:

{
  # Add fonts to system
  fonts.packages = with pkgs;
     map (font: font.overrideAttrs {preferLocalBuild = true;}) [
	roboto
	noto-fonts
	noto-fonts-cjk-sans
	noto-fonts-cjk-serif
	twemoji-color-font
	font-awesome
	victor-mono
	iosevka-bin
	nerdfonts

  ];
}
