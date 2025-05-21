{
  description = "NanSuS Desktop flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-utils.url = "github:numtide/flake-utils";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
  };



  };

  outputs = {

      self,
      nixpkgs, 
      flake-utils,
      hyprland,
      home-manager,
      nixos-hardware     
      }@inputs:


    let

      # ---- SYSTEM SETTINGS ----
      systemSettings = {
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        #pkgs = nixpkgs.legacyPackages."x86_64-linux";
	pkgs = import nixpkgs {
	   system = systemSettings.system;
  	   config.allowUnfree = true;
	};
        hostname = "NanSuS";

	# !!! Change these depending on which host is in use !!!
	# ~/.dotfiles/hosts/<host_name>
        host = "Laptop";
	# change this per-host: "laptop" or "slave"
	# for correct drivers and such
	hostType = "laptop";

        timezone = "Europe/Helsinki";
        locale = "fi_FI.UTF-8";
      };

      # ----- USER SETTINGS -----
      userSettings = rec {
        username = "nansus";
        name = "NanSuS";
        term = "kitty";
      };

    in {
      nixosConfigurations = {
        nansus = systemSettings.lib.nixosSystem {
          inherit (systemSettings) system;
          modules = [
             "${self}/hosts/${systemSettings.host}/configuration.nix"

	     # Choose right hardware modules according to machine
	     # for up to date drivers
	     (if systemSettings.hostType == "desktop" then
	        nixos-hardware.nixosModules.lenovo-legion-t526amr5
	     else if systemSettings.hostType == "laptop" then
                nixos-hardware.nixosModules.lenovo-legion-16ithg6
             #else if systemSettings.hostType == "slave" then
                #./hosts/slave/custom.nix
	     else
		throw "unknown hostType: ${systemSettings.hostType}")


	     #nixos-hardware.nixosModules.lenovo-legion-t526amr5

	    ./system/base/shells/zsh.nix
          ];
          specialArgs = {
            inherit systemSettings userSettings inputs;
            pkgs = systemSettings.pkgs;
          };
        };
      };

      homeConfigurations = {
        nansus = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = systemSettings.pkgs;
          extraSpecialArgs = {
            inherit systemSettings userSettings;

	    configPath = "${self}/hosts/${systemSettings.host}/.config";
          };
          modules = [
	      "${self}/hosts/${systemSettings.host}/home.nix"



          ];
        };
      };
    };
}
