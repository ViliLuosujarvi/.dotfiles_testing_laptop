## Updated flake.nix

```nix
{
  description = "NanSuS Desktop flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home Manager input
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware modules for laptop/desktop
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: let
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
      hostname = "NanSuS";
      hostType = "laptop"; # adjust per-host
      in {
      # NixOS system configuration
      nixosConfigurations = {
        ${hostname} = pkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # Base system configuration
            ./hosts/Laptop/configuration.nix

            # Hardware-specific modules
            (if hostType == "laptop" then
              nixos-hardware.nixosModules.lenovo-legion-16ithg6
            else
              nixos-hardware.nixosModules.lenovo-legion-t526amr5)

            # Shells
            ./system/base/shells/zsh.nix

            # Integrate Home Manager as NixOS module
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = ".backup";
              home-manager.users.nansus = ./hosts/Laptop/home.nix;
            }
          ];
          # pass args
          specialArgs = { inherit pkgs; };
        };
      };
    });
}
