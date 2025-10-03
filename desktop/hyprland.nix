{ config, pkgs, ... }:

{

  # Enable the Hyprland Desktop Environment.
  programs.hyprland = { 
    enable = true;
    withUWSM = false;
    xwayland.enable = false;
  };

  # XDG Portal for hyprland
  # Build error
  #xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    #alacritty
    #dunst
    brightnessctl
    hyprlandPlugins.hyprbars
    hyprpanel
    kitty
    networkmanagerapplet
    rofi
    swaybg
    swayidle
    swaylock
    #swww
    wireplumber
    #waybar
    wofi

    #(waybar.overrideAttrs (oldAttrs: {
    #    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #}))

  ];

}
