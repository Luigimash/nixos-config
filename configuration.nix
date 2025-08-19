# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # nixos hardware framework 13 amd ai 9 hx370 optimizations
      <nixos-hardware/framework/13-inch/amd-ai-300-series>
    ];

  # Bootloader. needed for dual boot to work
  boot.loader.grub = {
    enable=true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  # boot.loader.systemd-boot.enable = true; # disabled in favour of GRUB
  boot.loader.efi.canTouchEfiVariables = true;

  # Additional optimizations for amd ai 9 hx370 chip
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.power-profiles-daemon.enable = true;
  services.tlp.enable = false; #don't use both tlp and power-profiles-daemon 
  # Firmware updates (framework? claude recommend)
  services.fwupd.enable = true;

  networking.hostName = "loojy"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.me = {
    isNormalUser = true;
    description = "Jackie";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pkgs.libsForQt5.kdenlive
    pkgs.kdePackages.kdenlive
    pkgs.obsidian
    pkgs.pinta
    pkgs.gimp3-with-plugins
    pkgs.obs-studio
    pkgs.vlc
    pkgs.discord
    pkgs.steam
    pkgs.protonup-qt
 #   pkgs.code-cursor # Cursor seems to be outdated, 1.2.1 at time of writing when newest is 1.4
    pkgs.vscode
    pkgs.claude-code
    pkgs.anki
    pkgs.libreoffice-still
    pkgs.figma-linux
#    pkgs.notion-app
    pkgs.docker
    pkgs.slack
    pkgs.pureref
    pkgs.spotify
    pkgs.wechat
    nodejs_20
    pkgs.bitwarden-desktop

    pkgs.usbutils
    pkgs.hardinfo2
    
    # CLI tools
    vim
    pkgs.btop 
    pkgs.ffmpeg_6
    pkgs.fastfetchMinimal
    wget
    pkgs.git
    pkgs.bitwarden-cli
    # Framework stuff
    os-prober
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
    programs.steam.enable = true;
    virtualisation.docker.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable Tailscale
  services.tailscale.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  # -------------------
  # FRAMEWORK 13 LOOJY AUTOBACKUP
  # -------------------
  # Auto-backup configuration to Git on every rebuild
  system.activationScripts.backup-config = {
  text = ''
    cd /etc/nixos
    echo "Starting NixOS configuration backup" 
    
    # Set Git identity for this operation
    export GIT_AUTHOR_NAME="NixOS Auto Backup"
    export GIT_AUTHOR_EMAIL="nixos-backup@$(hostname)"
    export GIT_COMMITTER_NAME="NixOS Auto Backup" 
    export GIT_COMMITTER_EMAIL="nixos-backup@$(hostname)"
    
    # Add all changes
    ${pkgs.git}/bin/git add . 2>/dev/null || true
    
    # Commit 
    ${pkgs.git}/bin/git commit -m "Auto-backup: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null || true
    ${pkgs.git}/bin/git push origin framework13-loojy 2>/dev/null || true
    echo "✓ NixOS configuration backed up to Git!"
  '';
  deps = [ "etc" ];
  };

}
