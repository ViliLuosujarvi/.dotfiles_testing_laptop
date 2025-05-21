{

   description = "NanSuS Desktop flake"

   inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

      home-manager.url = "github:nix-community/home-manager/release-24.11";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hyprland = {
      url = "github:hyprwm/Hyprland/v0.44.1?submodules=true";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprland-plugins.git";
      rev = "4d7f0b5d8b952f31f7d2e29af22ab0a55ca5c219"; #v0.44.1
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprgrass.url = "github:horriblename/hyprgrass/427690aec574fec75f5b7b800ac4a0b4c8e4b1d5";
    hyprgrass.inputs.hyprland.follows = "hyprland";

    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "emacs-pin-nixpkgs";

   };

   outputs = { self, nixpkgs, ... }:
      let
              # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux"; # system arch
	lib = nixpkgs.lib;
	pkgs = nixpkgs.legacyPackages.${system};
        hostname = "NanSuS"; # hostname
	host = "Home-Desktop"; # Select profile from ~/.dotfiles/hosts
        timezone = "America/Chicago"; # select timezone
        locale = "en_US.UTF-8"; # select locale
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "nansus"; # username
        name = "NanSuS"; # name/identifier
        email = "vililuosujarvi135@gmail.com"; # email (used for certain configurations)
        dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
	home-manager = home-manager-stable; # home manager branch
        term = "kitty"; # Default terminal command;
        font = "Intel One Mono"; # Selected font
        fontPkg = pkgs.intel-one-mono; # Font package
	editor = "nano"; # Default editor;
      };

      #pkgs-emacs = import inputs.emacs-pin-nixpkgs {
      #  system = systemSettings.system;
      #};

      in {
      nixosConfigurations = {
         nansus = lib.nixosSystem {
	    inherit (systemSettings) system;
	    modules = [
               ("${userSettings.dotfilesDir}/hosts/${systemSettings.host}/configuration.nix")
             ];
	    extraSpecialArgs = {
              # pass config variables from above
              inherit pkgs;
              inherit pkgs-emacs;
              inherit systemSettings;
              inherit userSettings;
              inherit inputs;
            };
	 };
      };
      homeConfigurations = {
	 nansus = inputs.home-manager.lib.homeManagerConfiguration {
	    inherit (systemSettings)  pkgs;
	    modules = [ 
	       home.file = {
		  ".config" = {
		      source =  "${userSettings.dotfilesDir}/hosts/${systemSettings.host}/.config";
		      recursive = true;
		  };
               };
	      # (./. + "/.dotfiles/hosts" + ("/" + systemSettings.host) + "/configuration.nix")
	    ];
	 };
      };
   };

}
