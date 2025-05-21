{pkgs, ...}:

{
  # Enable gnome based lockscreen
  services.xserver = {
     enable = true;
     displayManager.gdm.enable = true;

  };
}
