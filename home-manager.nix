{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball 
    "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  imports = [ 
    (import "${home-manager}/nixos") 
  ];

  # Configure home-manager for your user
  home-manager.users.me = { pkgs, ... }: {
    home.packages = [
      pkgs.git
      pkgs.htop
      # Add your packages here
    ];\
    
    programs.bash.enable = true;
    
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "25.05";
  };
}
