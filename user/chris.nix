{ config, pkgs, ... }:
{
  # Home-manager configuration is now handled in flake.nix

  users.users.chris = {
    
    isNormalUser = true;
    description = "Christian Elberfeld";

    # Set an initial password to be changed later
    initialPassword = "Pass@word1+";

    # Set default shell 
    # shell = pkgs.nushell;
    
    extraGroups = [ 

      # user can set network options 
      "networkmanager"
      
      # user can use sudo 
      "wheel"
      
      # user can control virtual machines
      "libvirtd"
      "vboxusers"

      # user can use docker
      "docker"
      
    ];

  };

  
  home-manager.users.chris = { pkgs, ... }: {

    programs = {

      git = {
        enable = true;
        settings.user = {
          name  = "Christian Elberfeld";
          email = "6413499+elberfeld@users.noreply.github.com";
        };
      };

    }; 


    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

}
