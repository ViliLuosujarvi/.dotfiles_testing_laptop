{ pkgs, ... }:

{
  #environment.systemPackages = with pkgs; [ steam mangohud protonup-qt lutris bottles heroic ];

  programs = {
       steam = {
          enable = true;
  	  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  	  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  	  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
       }; 
   };

  programs.gamemode.enable = true;

  hardware.opengl.driSupport32Bit = true;

}
