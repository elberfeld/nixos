{ config, pkgs, ... }:
{
  # Home-manager configuration is now handled in flake.nix

  users.users.nixos = {
    
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

  
  home-manager.users.nixos = { pkgs, ... }: {

    programs = {

      bash = {
        enable = true;
        bashrcExtra = ''
          export SSH_AUTH_SOCK=/tmp/wincrypt-hv.sock
          ss -lnx | grep -q $SSH_AUTH_SOCK
          if [ $? -ne 0 ]; then
            rm -f $SSH_AUTH_SOCK
            (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork SOCKET-CONNECT:40:0:x0000x33332222x02000000x00000000 >/dev/null 2>&1)
          fi

          fastfetch --structure "title:separator:os:host:kernel:uptime:shell:display:terminal:cpu:gpu:memory:swap:disk:locale"
          (sleep 1 && ssh-add -l) &
        '';
      };

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
    home.stateVersion = "25.11";
  };

}
