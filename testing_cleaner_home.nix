{ config, pkgs, lib, ... }:

{
  # User identity
  home.username     = "nansus";
  home.homeDirectory = "/home/nansus";

  # Keep stateVersion in sync with Home Manager release
  home.stateVersion = "24.11";

  # Install desired packages
  home.packages = with pkgs; [
    git   # Git version control
    gh    # GitHub CLI
    kitty # Terminal emulator
  ];

  # Configure Git
  programs.git.enable = true;
  programs.git.userName  = "NanSuS";
  programs.git.userEmail = "vili.luosujarvi@edu.lapinamk.fi";

  # Enable Home Manager self-management
  programs.home-manager.enable = true;
}
