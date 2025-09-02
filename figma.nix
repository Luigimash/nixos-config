{ config, pkgs, ... }:

let
  figma-linux-hw-accel = pkgs.symlinkJoin {
    name = "figma-linux-hw-accel";
    paths = [ pkgs.figma-linux ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/figma-linux \
        --add-flags "--enable-features=VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks,UseOzonePlatform,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo,Vulkan,VulkanFromANGLE,DefaultANGLEVulkan" \
        --add-flags "--enable-accelerated-2d-canvas" \
        --add-flags "--enable-accelerated-video-decode" \
        --add-flags "--enable-gpu-rasterization" \
        --add-flags "--enable-zero-copy" \
        --add-flags "--enable-hardware-overlays" \
        --add-flags "--ignore-gpu-blocklist" \
        --add-flags "--use-gl=desktop" \
        --add-flags "--use-vulkan" \
        --add-flags "--enable-oop-rasterization"
    '';
  };
in
{
  # Install the hardware-accelerated figma-linux package
  environment.systemPackages = [
    figma-linux-hw-accel
  ];
}
