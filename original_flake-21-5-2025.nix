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

	# Change this depending on
	# which host is in use
	# ~/.dotfiles/hosts/<host_name>
        host = "Home-Desktop";

        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
      };

      # ----- USER SETTINGS -----
      userSettings = rec {
        username = "nansus";
        name = "NanSuS";
        email = "vililuosujarvi135@gmail.com";
        term = "kitty";
        font = "Intel One Mono";
        fontPkg = systemSettings.pkgs.intel-one-mono;
        editor = "nano";
      };

    in {
      nixosConfigurations = {
        nansus = systemSettings.lib.nixosSystem {
          inherit (systemSettings) system;
          modules = [
             "${self}/hosts/${systemSettings.host}/configuration.nix"

	     nixos-hardware.nixosModules.lenovo-legion-t526amr5

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
          };
          modules = [
	      "${self}/hosts/${systemSettings.host}/home.nix"

	      {
              home.username = userSettings.username;
              home.homeDirectory = "/home/${userSettings.username}";
              home.stateVersion = "24.11";
	      
              home.file.".config" = {
                source = "${self}/hosts/${systemSettings.host}/.config";
                recursive = true;
              };

              programs.home-manager.enable = true;
              }
          ];
        };
      };
    };
}
