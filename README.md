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

# Then add it to the host's module list in flake.nix
```

4. Build and switch to your configuration:
```bash
# Replace <hostname> with one of: void-carbonx1, void-desktop, void-yoga, adesso-wsl
sudo nixos-rebuild switch --flake .#<hostname>
```

5. Adjust origing url for pull wthout SSH Key 
```bash
git remote set-url origin https://github.com/elberfeld/nixos.git
git remote set-url --push origin git@github.com:elberfeld/nixos.git
```

## Available Configurations

- **void-carbonx1**: ThinkPad X1 Carbon Gen 10 Laptop
- **void-desktop**: Desktop PC (Intel Skylake, GeForce GTX 1650)
- **void-yoga**: ThinkPad Yoga Laptop   
- **adesso-wsl**: WSL2 on Windows 11

## Configuration Structure

```
├── flake.nix              # Main flake configuration
├── hosts/                 # Host-specific configurations
├── desktop/               # Desktop environment modules
├── hardware/              # Hardware-specific modules (camera, GPU, TPM)
├── shared/                # Shared system modules
├── thirdparty/            # Vendor drivers packaged locally
└── user/                  # User configurations
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

Yubikey support for SSH keys (via gpg-agent) is already included in `shared/physicalmachine.nix`:

```nix
services.udev.packages = [ pkgs.yubikey-personalization ];

programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
};
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

