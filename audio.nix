# Audio configuration for Framework 13 AMD Ryzen AI 300 Series
{ config, pkgs, ... }:

{
  # Enable sound with pipewire
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

  # Framework 13 AMD AI 300 headset microphone fix
  # This enables TRRS (headset with microphone) detection on the 3.5mm jack
  boot.extraModprobeConfig = ''
    options snd-hda-intel index=1,0 model=auto,dell-headset-multi
  '';

  # Audio-related packages
  environment.systemPackages = with pkgs; [
    pulseaudio     # for pactl, pacmd, etc. (PipeWire compatibility)
    alsa-utils     # for alsamixer, alsactl, amixer
  ];
}
