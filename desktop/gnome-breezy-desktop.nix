{ config, pkgs, lib, ... }:

let
  breezy-desktop = pkgs.stdenv.mkDerivation {
    name = "breezy-desktop";
    src = pkgs.fetchFromGitHub {
      owner = "wheaney";
      repo = "breezy-desktop";
      rev = "main"; # Or use a specific commit/tag
      sha256 = "sha256-EutSAsrBzkVM+AEFSZkdt2KypTYbM1lzzY+jWDXJMZU="; # Use the correct hash from the error message
    };
    
    # Fix the broken symlinks by creating the missing target files
    postUnpack = ''
      cd $sourceRoot
      
      # Create the target directories
      mkdir -p modules/sombrero/
      
      # Create empty placeholder files for the missing targets
      touch modules/sombrero/calibrating.png
      touch modules/sombrero/Sombrero.frag
      
      # Remove broken symlinks and create new ones pointing to our placeholder files
      if [ -L gnome/src/textures/calibrating.png ]; then
        rm gnome/src/textures/calibrating.png
      fi
      
      # Make sure the directory exists
      mkdir -p gnome/src/textures/
      ln -sf ../../../modules/sombrero/calibrating.png gnome/src/textures/calibrating.png
      
      if [ -L gnome/src/Sombrero.frag ]; then
        rm gnome/src/Sombrero.frag
      fi
      
      # Make sure the directory exists
      mkdir -p gnome/src/
      ln -sf ../../modules/sombrero/Sombrero.frag gnome/src/Sombrero.frag
    '';
    
    installPhase = ''
      mkdir -p $out/share/gnome-shell/extensions/breezy-desktop@wheaney
      cp -r * $out/share/gnome-shell/extensions/breezy-desktop@wheaney/
    '';
  };
in
{
  # Your existing NixOS configuration...
  
  # Add the extension to system packages
  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnome-shell-extensions
    breezy-desktop
  ];
  
  # Add a user activation script to enable the extension
  system.userActivationScripts = {
    linkBreezyDesktop = {
      text = ''
        EXTENSION_DIR="$HOME/.local/share/gnome-shell/extensions/breezy-desktop@wheaney"
        
        # Create the extensions directory if it doesn't exist
        mkdir -p "$HOME/.local/share/gnome-shell/extensions/"
        
        # Remove existing extension if it exists
        if [ -e "$EXTENSION_DIR" ]; then
          rm -rf "$EXTENSION_DIR"
        fi
        
        # Create a symlink to the Nix store location
        ln -sf ${breezy-desktop}/share/gnome-shell/extensions/breezy-desktop@wheaney "$EXTENSION_DIR"
        
        # Optionally run the setup script if needed
        if [ -x "$EXTENSION_DIR/gnome/bin/setup" ]; then
          cd "$EXTENSION_DIR/gnome"
          ./bin/setup || true
        fi
      '';
    };
  };
}


