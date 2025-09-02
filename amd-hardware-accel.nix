{ config, pkgs, ... }:

{
  # Enable AMD graphics acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    
    # AMD-specific packages for hardware acceleration
    extraPackages = with pkgs; [
      # Mesa RADV (Vulkan) and RadeonSI (OpenGL) drivers
      mesa
      
      # VA-API support for video acceleration
      libvdpau-va-gl
      
      # AMD ROCm OpenCL support (for compute workloads)
      rocmPackages.clr.icd
    ];
    
    # 32-bit support for compatibility
    extraPackages32 = with pkgs; [
      driversi686Linux.mesa
    ];
  };

  # Environment variables for optimal AMD GPU performance
  environment.sessionVariables = {
    # Enable Wayland support for Electron apps and other applications
    # This often provides better performance and hardware acceleration
    NIXOS_OZONE_WL = "1";
    
    # Ensure AMD GPU uses RADV (the open-source Vulkan driver)
    AMD_VULKAN_ICD = "RADV";
    
    # Enable VA-API for video acceleration
    LIBVA_DRIVER_NAME = "radeonsi";
  };

  # Install hardware acceleration debugging and monitoring tools
  environment.systemPackages = with pkgs; [
    libva-utils      # vainfo command to check VA-API
    vulkan-tools     # vulkaninfo command to check Vulkan
    clinfo           # Check OpenCL support
    mesa-demos       # glxinfo for OpenGL info
    radeontop        # Monitor AMD GPU usage
    gpu-viewer       # GUI tool to view GPU information
  ];
}
