{ config, pkgs, ... }:

{

  # Login Manager SDDM with custom Theme 

  services.xserver.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    theme = "where-is-my-sddm-theme";
  };

  environment.systemPackages = let themes = pkgs.callPackage ../nixpkgs/sddm-themes.nix {}; in [ 
    themes.where-is-my-sddm-theme 
  ];


}
