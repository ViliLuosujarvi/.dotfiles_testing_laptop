{pkgs, ... }:

{
  #Enable Hyprland
  programs.hyprland = {
     enable = true;
     xwayland.enable = true;

  };

environment.systemPackages = with pkgs; [
     # Hyprland related software
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
  ];
  
}
