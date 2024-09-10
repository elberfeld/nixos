{ config, pkgs, ... }:

{

  # Display Manager LightDM 

  # Planned:
  ## Theme: https://github.com/NoiSek/Aether
  ## Greeter: https://github.com/MerkeX/lightdm-webkit2-greeter

  services.displayManager.lightdm = {
    enable = true;
    #greeter.name = "lightdm-webkit2-greeter";
    greeters.enso.enable = true;
  };

}
