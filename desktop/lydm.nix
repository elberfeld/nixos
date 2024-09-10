{ config, pkgs, ... }:

{

  # Display Manager Ly
  # https://github.com/fairyglade/ly

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      clear_password = true;
      clock = "%c";
      lang = "de";
      load = true;
      numlock = false;
      save = true;
    };
  };

  environment.systemPackages = with pkgs; [

    cmatrix    
  ];

}
