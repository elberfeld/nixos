{ config, pkgs, ... }:
{

  imports = [ <home-manager/nixos> ];

  users.users.chris = {
    isNormalUser = true;
    description = "Christian Elberfeld";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };
  
  home-manager.users.chris = { pkgs, ... }: {

    programs.git = {
      enable = true;
      userName  = "Christian Elberfeld";
      userEmail = "6413499+elberfeld@users.noreply.github.com";
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

}
