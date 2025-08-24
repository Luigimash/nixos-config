{ config, lib, pkgs, ... }:

# Complete configuration for accessing iOS device contents
{
  # Enable the usbmuxd service (this is crucial!)
  services.usbmuxd.enable = true;
  
  # Enable GVFS for GUI file manager support
  services.gvfs.enable = true;
  
  # Enable gphoto2 support for camera/photo access
  programs.gphoto2.enable = true;
  
  # Optional: Use usbmuxd2 if you have issues with the default
  # services.usbmuxd = {
  #   enable = true;
  #   package = pkgs.usbmuxd2;
  # };

  # Install required packages
  environment.systemPackages = with pkgs; [
    pkgs.ifuse              # for mounting iOS device filesystem
    pkgs.libimobiledevice   # core iOS device communication
    pkgs.libusbmuxd        # USB multiplexing library
    pkgs.ideviceinstaller  # for installing/managing apps
    pkgs.usbmuxd           # USB multiplexing daemon
    pkgs.exfat             # exFAT filesystem support
    pkgs.gnome.gvfs        # for GUI file managers
    pkgs.gvfs              # Virtual file system
    pkgs.gphoto2           # command-line photo access tool
  ];

  # Make sure your user is in the usbmux group
  # Replace "yourusername" with your actual username
  users.users.me = {
    # ... your other user config ...
    extraGroups = [ 
      "wheel"    # if you need sudo
      "usbmux"   # THIS IS IMPORTANT for iOS access
      "camera"   # IMPORTANT for gphoto2/photo access
      # ... any other groups you need ...
    ];
  };
}
