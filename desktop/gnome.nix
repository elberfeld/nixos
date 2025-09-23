{ config, pkgs, lib, ... }:

{

  # Enable the GNOME Plasma Desktop Environment.
  # Add extra setting to enable fractional scaling, see https://discourse.nixos.org/t/how-to-set-fractional-scaling-via-nix-configuration-for-gnome-wayland/56774
  services.desktopManager.gnome = {
    enable = true;
    extraGSettingsOverridePackages = [ pkgs.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';
  };
  
  # XDG Portal for kde
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];

  # Avoid Conflicts wih KDE
  programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";

  # Exclude default Packages 
  # environment.gnome.excludePackages = with pkgs; [

  # ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gparted
  ];

}
