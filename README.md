# NixOS Configurations

A modern NixOS configuration using Nix flakes for reproducible system builds.

## Quick Start

1. Clone this repository:
```bash
git clone git@github.com:elberfeld/nixos.git
cd nixos
```

2. Enable flakes (if not already enabled):
```bash
# Add to /etc/nixos/configuration.nix or set temporarily:
export NIX_CONFIG="experimental-features = nix-command flakes"
```

3. Copy your hardware configuration:
```bash
# For physical machines, copy the hardware configuration:
sudo cp /etc/nixos/hardware-configuration.nix hosts/<hostname>-hardware.nix

# Then uncomment the import line in hosts/<hostname>.nix
```

4. Build and switch to your configuration:
```bash
# Replace <hostname> with one of: void-carbonx1, void-yoga, adesso-wsl
sudo nixos-rebuild switch --flake .#<hostname>
```

## Available Configurations

- **void-carbonx1**: ThinkPad X1 Carbon Gen 10 Laptop
- **void-yoga**: ThinkPad Yoga Laptop   
- **adesso-wsl**: WSL2 on Windows 11

## Configuration Structure

```
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
├── desktop/               # Desktop environment modules
├── shared/                # Shared system modules
├── user/                  # User configurations
└── nixpkgs/              # Custom packages
```

## Usage Commands

### System Management
```bash
# Switch to configuration
sudo nixos-rebuild switch --flake .#<hostname>

# Test configuration without activation
sudo nixos-rebuild test --flake .#<hostname>

# Build and prepare for next boot
sudo nixos-rebuild boot --flake .#<hostname>

# Update flake inputs
nix flake update

# Show configuration info
nix flake show
```

### Development
```bash
# Enter development shell
nix develop

# Build specific configuration
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel

# Test build without hardware requirements (dry-run)
nix build .#nixosConfigurations.<hostname>.config.system.build.toplevel --dry-run
```

## Clone with SSH Key from Yubikey 

The following extensions in your host configuration enable Yubikey support:

```nix
# Already included in shared/yubikey.nix
services.yubikey-agent.enable = true;
```

## WSL Usage

### Installation

1. Follow the [NixOS-WSL installation guide](https://nix-community.github.io/NixOS-WSL/install.html)

2. Import using Windows CMD (stores VHD in `%USERPROFILE%\NixOS\`):
```cmd
wsl --import NixOS %USERPROFILE%\NixOS\ %USERPROFILE%\Downloads\nixos-wsl.tar.gz --version 2
```

3. First boot and setup:
```bash
# Clone this repository
git clone git@github.com:elberfeld/nixos.git
cd nixos

# Apply WSL configuration
sudo nixos-rebuild switch --flake .#<hostname>
```

4. Restart WSL:
```cmd
wsl --shutdown
```

### SSH Agent with WinCrypt

```bash
export SSH_AUTH_SOCK=/tmp/wincrypt-hv.sock
ss -lnx | grep -q $SSH_AUTH_SOCK
if [ $? -ne 0 ]; then
    rm -f $SSH_AUTH_SOCK
    (setsid nohup socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork SOCKET-CONNECT:40:0:x0000x33332222x02000000x00000000 >/dev/null 2>&1)
fi
ssh-add -l
```

