{ config, lib, pkgs, ... }:

{
  # Safe boot optimization for NixOS 25.05
  # Focuses on proven optimizations that don't break functionality
  
  # Safe kernel parameters for faster boot
  boot.kernelParams = [
    "quiet"                    # Reduce boot messages
    "loglevel=3"              # Reduce kernel logging
    "systemd.log_level=warning" # Reduce systemd logging
    "rd.systemd.show_status=false" # Hide systemd status messages
    "rd.udev.log_priority=3"   # Reduce udev logging
  ];
  
  # Safe systemd optimizations
  systemd.extraConfig = ''
    # Reasonable timeout reductions (not aggressive)
    DefaultTimeoutStartSec=30s
    DefaultTimeoutStopSec=15s
    DefaultRestartSec=2s
  '';
  
  # Optimize journald for speed while keeping functionality
  services.journald.extraConfig = ''
    # Store in memory + persistent, but optimized
    Storage=persistent
    RuntimeMaxUse=64M
    SystemMaxUse=512M
    MaxFileSec=1week
    MaxRetentionSec=4week
    
    # Compress for space savings
    Compress=yes
    
    # Reasonable sync interval
    SyncIntervalSec=30s
  '';
  
  # Safe service optimizations - disable only non-essential services
  systemd.services = {
    # Disable NetworkManager-wait-online (network still works)
    NetworkManager-wait-online.enable = false;
    
    # Disable ModemManager if no cellular modem (safe for laptops)
    ModemManager.enable = lib.mkDefault false;
    
    # These are safe to disable for faster boot
    systemd-update-utmp.enable = false;
    systemd-journal-catalog-update.enable = false;
  };
  
  # Safe filesystem optimizations
  fileSystems."/" = {
    options = lib.mkAfter [
      "noatime"        # Don't update access times (safe performance boost)
      "commit=30"      # Sync every 30 seconds instead of default 5
    ];
  };
  
  # Safe boot loader timeout reduction
  boot.loader.timeout = lib.mkDefault 2;
  
  # Keep only last 10 generations (reasonable cleanup)
  boot.loader.systemd-boot.configurationLimit = 10;
  
  # Safe power management for faster startup
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  
  # Safe networking optimizations
  networking.dhcpcd.extraConfig = ''
    # Faster DHCP discovery
    noarp
    option rapid_commit
  '';
  
  # Enable systemd in initrd for parallel initialization (safe)
  boot.initrd.systemd.enable = true;
  
  # Safe kernel optimizations
  boot.kernel.sysctl = {
    # Reasonable dirty page writeback timing
    "vm.dirty_background_ratio" = 10;
    "vm.dirty_ratio" = 20;
    "vm.dirty_expire_centisecs" = 3000;
    "vm.dirty_writeback_centisecs" = 1500;
  };
}