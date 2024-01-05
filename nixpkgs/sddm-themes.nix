{ stdenv, fetchFromGitHub }:
{
  # Additional SDDM-Themes 
  # Sample from: https://github.com/michaelpj/nixos-config/blob/e5be6d0f0e431748c0a8c532f9776c14e67ed8c9/nixpkgs/pkgs/sddm-themes.nix
  
  sddm-sugar-dark = stdenv.mkDerivation rec {
    pname = "sddm-sugar-dark-theme";
    version = "1.2";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src $out/share/sddm/themes/sugar-dark
    '';
    src = fetchFromGitHub {
      owner = "MarianArlt";
      repo = "sddm-sugar-dark";
      rev = "v${version}";
      sha256 = "0gx0am7vq1ywaw2rm1p015x90b75ccqxnb1sz3wy8yjl27v82yhb";
    };
  };

  where-is-my-sddm-theme = stdenv.mkDerivation rec {
    pname = "where-is-my-sddm-theme";
    version = "159793c0a9085a7a97d9feb9edbe9a42bec35977";
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -aR $src/where_is_my_sddm_theme $out/share/sddm/themes/where-is-my-sddm-theme
    '';
    src = fetchFromGitHub {
      owner = "stepanzubkov";
      repo = "where-is-my-sddm-theme";
      rev = "${version}";
      sha256 = "rhKRSNWMO5a7NV66TTUaohqkUmx54+hGeeWApRDFTyg=";
    };
  };

}