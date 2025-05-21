{...}:

{

  # Define hostname
  networking.hostName = "NanSuS";

  # Enable networkmanager
  networking.networkmanager.enable = true;

  # Disable wait process
  systemd.services.NetworkManager-wait-online.enable = false;

}
