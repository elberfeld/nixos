{ config, pkgs, ... }:

{

  # Plasma Login Manager 
  
  services.displayManager.plasma-login-manager = {
    enable = true;
  };

}
