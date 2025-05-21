{ config, pkgs, configPath,  ... }:

{
  home.username = "nansus";
  home.homeDirectory = "/home/nansus";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    git
    gh
    kitty
  ];

  programs.git = {
    enable = true;
    userName  = "ViliLuosujarvi";
    userEmail = "vili.luosujarvi@edu.lapinamk.fi";
  };

  home.file.".config" = {
    source = configPath;
    #source = "${self}/hosts/Laptop/.config";
    recursive = true;
  };

  programs.home-manager.enable = true;
}
