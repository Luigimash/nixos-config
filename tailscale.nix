# Tailscale setup, it's weird and finnicky cuz of some build bug - hopefully resolved in the future https://github.com/NixOS/nixpkgs/issues/438765
{ config, pkgs, ... }:

{
    boot.kernelPatches = [
      # Fix the /proc/net/tcp seek issue
      # Impacts tailscale: https://github.com/tailscale/tailscale/issues/16966
      {
        name = "proc: fix missing pde_set_flags() for net proc files";
        patch = pkgs.fetchurl {
          name = "fix-missing-pde_set_flags-for-net-proc-files.patch";
          url = "https://patchwork.kernel.org/project/linux-fsdevel/patch/20250821105806.1453833-1-wangzijie1@honor.com/raw/";
          hash = "sha256-DbQ8FiRj65B28zP0xxg6LvW5ocEH8AHOqaRbYZOTDXg=";
        };
      }
    ];
    
  # Enable Tailscale
  #services.tailscale.enable = true;
}
