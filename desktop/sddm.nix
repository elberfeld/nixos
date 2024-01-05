{ config, pkgs, ... }:

{

  # Login Manager SDDM with custom Theme 

  # List of interesting themes:
  # https://store.kde.org/p/1692328
  # https://store.kde.org/p/2102227
  # https://store.kde.org/p/2056189
  # https://store.kde.org/p/2091569
  # WarGames: https://store.kde.org/p/2072906
  # https://store.kde.org/p/1994287
  # Terminal: https://store.kde.org/p/1949572
  # https://store.kde.org/p/1534637
  # https://store.kde.org/p/1366843
  # https://store.kde.org/p/1430814
  # Zust: https://github.com/stepanzubkov/sddm-zust/tree/main
  
  services.xserver.displayManager.sddm = {
    enable = true;
    enableHidpi = true;
    wayland.enable = true;
    theme = "where-is-my-sddm-theme";
  };

  # Workaround to disable onscreen Keyboard, see: https://github.com/NixOS/nixpkgs/issues/55423
  #services.xserver.displayManager.sddm.extraConfig = ''
  #  [General]
  #  InputMethod=
  #'';
  services.xserver.displayManager.sddm.settings = {
    General = {
      InputMethod = "";
    };
  };

  environment.systemPackages = let themes = pkgs.callPackage ../nixpkgs/sddm-themes.nix {}; in [ 
    themes.where-is-my-sddm-theme 
  ];


}
