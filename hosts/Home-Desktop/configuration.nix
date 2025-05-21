{ config, pkgs, lib, systemSettings, userSettings, ... }:

{
  imports =
    [ 
      # ---- Hardware ----
      ../../hosts/Home-Desktop/Desktop-hw.nix

      # ----  Base  ----
      ../../system/base/boot.nix
      ../../system/base/gnome_lockscreen.nix
      ../../system/base/keymap.nix
      ../../system/base/unfree_software.nix
      ../../system/base/fonts.nix
      ../../system/base/hyprland.nix
      ../../system/base/networking.nix
      ../../system/base/locale.nix

	# hostname
      ../../system/base/hostnames/Home-Desktop.nix
	
      # ---- Shell ----
      ../../system/base/shells/zsh.nix

      # ---- hardware ----
      ../../system/hardware/power.nix
      ../../system/hardware/systemd.nix
      ../../system/hardware/opengl.nix
      ../../system/hardware/time_syncd.nix

      # ---- App ----
      ../../system/app/discord.nix
      ../../system/app/thunar.nix
      ../../system/app/libreOffice.nix
      ../../system/app/vscode.nix
      ../../system/app/browser/firefox.nix

      # ---- games ----
      ../../system/games/steam.nix
      ../../system/games/prismlauncher.nix
      ../../system/games/tailscale.nix
      ../../system/games/gamemode.nix

      # ---- Security ----
      ../../system/security/automount.nix
      ../../system/security/firewall.nix
     ];




  environment.systemPackages = with pkgs; [
     # system related 
     wget
     networkmanagerapplet
     openssl
     pciutils

     # Personally needed software
     gh
     git
     btop
  ];

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Define the primary group for the user
  users.groups.nansus = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nansus = {
     isNormalUser = true;
     group = "nansus";
     description = "NanSuS-Desktop";
     extraGroups = [
	"wheel" # Sudo for nansus
	"networkmanager" # ability to change internet connections
	"video" # change display settings
	"vboxusers" # ability to use virtual machines
	"libvirtd" # -"-
	"lp"
	"input"
	"audio"

   ];
  };
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
