# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/legion/t526amr5"      
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Auto upgrade nixos-24.11 stable channel
  system.autoUpgrade.channel = "https://channels.nixos.org/nixos-24.11";


  networking.hostName = "NanSuS"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fi_FI.UTF-8";
    LC_IDENTIFICATION = "fi_FI.UTF-8";
    LC_MEASUREMENT = "fi_FI.UTF-8";
    LC_MONETARY = "fi_FI.UTF-8";
    LC_NAME = "fi_FI.UTF-8";
    LC_NUMERIC = "fi_FI.UTF-8";
    LC_PAPER = "fi_FI.UTF-8";
    LC_TELEPHONE = "fi_FI.UTF-8";
    LC_TIME = "fi_FI.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nansus = {
     isNormalUser = true;
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
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Thunar file manager
  programs.thunar.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     # system related 
     wget
     networkmanagerapplet
     openssl
     lsd
     fzf
     zsh
     oh-my-zsh
     pciutils
     brightnessctl
     btop
     tailscale

     # Hyprland related
     kitty
     waybar
     hyprpaper
#     wpaperd
#     mpvpaper
     swaybg
     swww
     nerdfetch
     rofi-wayland
     brightnessctl
     fastfetch
     wallust

     # Personally needed software
     gh
     git
     firefox
     prismlauncher
     direnv
     discord
  ];
  
  # Add fonts to system
  fonts.packages = with pkgs;
     map (font: font.overrideAttrs {preferLocalBuild = true;}) [
	roboto
	noto-fonts
#	noto-font-emoji
	noto-fonts-cjk-sans
	noto-fonts-cjk-serif
	twemoji-color-font
	font-awesome
	victor-mono
	iosevka-bin
	nerdfonts

  # Add cursors
#  xcursor-themes # Default cursor themes package
#  xcursor-simpleandsoft # Optional: A minimalistic black cursor
#  xcursor-breeze # Optional: Breeze cursor theme
   

  ];


  # Enable gnome based lockscreen
  services.xserver = {
     enable = true;
     displayManager.gdm.enable = true;

  };

  #Enable Hyprland
  programs.hyprland = {
     enable = true;
     xwayland.enable = true;

  };

  # Enable Zsh
  #environment.shells = with pkgs; [ zsh ];
    
  programs = {
  # Zsh configuration
      zsh = {
    	enable = true;
	enableCompletion = true;
      ohMyZsh = {
        enable = true;
	plugins = ["git" 
		  "virtualenv" 
		  "vi-mode"	
		 ];
        theme = "kennethreitz";
	# good ones been:
	# jonathan, candy, gnzh,
	# strug, xiong-chiamiov,
 	# kennethreitz, ys.
	# frontcube, rkj-repos,
	# kennethreitz  
      	};
      
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      promptInit = ''
      
        #pokemon colorscripts like. Make sure to install krabby package
        #krabby random --no-mega --no-gmax --no-regional --no-title -s; 

        # Set-up icons for files/folders in terminal using lsd
        alias ls='lsd'
        alias l='ls -l'
        alias la='ls -a'
        alias lla='ls -la'
        alias lt='ls --tree'

        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
        '';
      };
   };
 
  # Set ZSH as default shell
  #users.defaultUserShell = pkgs.zsh;  
  
  # Enable zsh
  #programs.zsh.enable = true;
  
  # Set ZSH as default shell for nansus
  users.users.nansus = {   
    shell = pkgs.zsh;
    };
 
  environment.shells = with pkgs; [ zsh ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
