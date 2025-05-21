{
  description = "NanSuS Desktop flake";

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
      rev = "4d7f0b5d8b952f31f7d2e29af22ab0a55ca5c219"; # v0.44.1
      inputs.hyprland.follows = "hyprland";
    };

    hyprlock = {
      type = "git";
      url = "https://code.hyprland.org/hyprwm/hyprlock.git";
      rev = "73b0fc26c0e2f6f82f9d9f5b02e660a958902763";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprgrass = {
      url = "github:horriblename/hyprgrass/427690aec574fec75f5b7b800ac4a0b4c8e4b1d5";
      inputs.hyprland.follows = "hyprland";
    };

    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs.nixpkgs.follows = "emacs-pin-nixpkgs";
    };
  };

  outputs = { self, nixpkgs, userSettings, systemSettings, ... }@inputs:
    let
      # ---- SYSTEM SETTINGS ---- #
      systemSettings = {
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        hostname = "NanSuS";
        host = "Home-Desktop";
        timezone = "America/Chicago";
        locale = "en_US.UTF-8";
      };

      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "nansus";
        name = "NanSuS";
        email = "vililuosujarvi135@gmail.com";
        term = "kitty";
        font = "Intel One Mono";
        fontPkg = systemSettings.pkgs.intel-one-mono;
        editor = "nano";
      };

      # Optional: Uncomment if/when using a pinned emacs input
      # pkgs-emacs = import inputs.emacs-pin-nixpkgs {
      #   system = systemSettings.system;
      # };

    in {
      nixosConfigurations = {
        nansus = systemSettings.lib.nixosSystem {
          inherit (systemSettings) system;
          modules = [
  	     "${self}/hosts/${systemSettings.host}/configuration.nix"
          ];
          extraSpecialArgs = {
            inherit (systemSettings) pkgs;
            # inherit pkgs-emacs; # uncomment if needed
            inherit systemSettings userSettings;
          };
        };
      };

      homeConfigurations = {
        nansus = inputs.home-manager.lib.homeManagerConfiguration {
          extraSpecialArgs = {
            inherit userSettings systemSettings inputs;
          };
          modules = [
	      "${self}/hosts/${systemSettings.host}/home.nix"

	      {
              home.username = userSettings.username;
              home.homeDirectory = "/home/${userSettings.username}";
              home.stateVersion = "24.11";

              home.file.".config" = {
                source = "${self}/.dotfiles/hosts/${systemSettings.host}/.config";
                recursive = true;
              };

              programs.home-manager.enable = true;
            }
          ];
        };
      };
    };
}
