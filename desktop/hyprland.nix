{ config, pkgs, ... }:

{

  # Enable the Hyprland Desktop Environment.
  programs.hyprland.enable = true;
  # programs.hyprland.xwayland.enable = true;

  # XDG Portal for hyprland
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    #alacritty
    dunst
    #kitty
    networkmanagerapplet
    rofi-wayland
    swaybg
    swayidle
    swaylock
    #swww
    waybar
    wofi

    (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))

  ];

}
