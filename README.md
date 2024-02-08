# NixOS Configurations

Clone this Repo and replace /etc/nixos/configuration.nix with a symlink to the configuration in this repo.

```
git clone git@github.com:elberfeld/nixos.git
ln -s /home/{username}/{git path}/{configfile}.nix /etc/nixos/configuration.nix 
```

## Setup Nix-Chanels

```
nix-channel --remove nixos
nix-channel --add https://nixos.org/channels/nixos-unstable nixos
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

## Clone with SSH Key from Yubikey 

The folowing extensions in configuration.nix are needed 

```
services.yubikey-agent.enable = true;
```

## Usage in WSL (preparation)

1. Insatllation Guide: https://nix-community.github.io/NixOS-WSL/install.html

2. Use this command for import (Windows CMD), so the VHD is stored in ```%USERPROFILE%\NixOS\```
```
wsl --import NixOS %USERPROFILE%\NixOS\ %USERPROFILE%\Downloads\nixos-wsl.tar.gz --version 2
```

3. Confugure and Update Nix-Channels 

4. Switch the defult user in configuration.nix and run ```nixos-rebuild boot ``` (do not use switch!)
```
  wsl.defaultUser = "chris";

  environment.systemPackages = with pkgs; [
    git
    nano
    socat
    wget
  ];

  users.users.chris = {
    
    isNormalUser = true;
    initialPassword = "Pass@word1+";
    
    extraGroups = [ 
      "networkmanager"
      "wheel"
    ];

  };

```

5. Force WSL to shotdown and relogin

```
wsl --shutdown
```

6. Manually load SSH Key from wincryptsshagent in windows and clone git Repo 

```
export SSH_AUTH_SOCK=/tmp/wincrypt-hv.sock
ss -lnx | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
        rm -f $SSH_AUTH_SOCK
  (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork SOCKET-CONNECT:40:0:x0000x33332222x02000000x00000000 >/dev/null 2>&1)
fi
ssh-add -l
```


