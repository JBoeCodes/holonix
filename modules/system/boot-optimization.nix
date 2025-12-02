{ config, lib, pkgs, ... }:

{
  # Aggressive boot optimization settings for lightning-fast startup
  
  # Disable NetworkManager-wait-online to speed up boot
  # Network will still work, just won't block boot waiting for full connectivity
  systemd.services.NetworkManager-wait-online.enable = false;
  
  # Kernel parameters for faster boot
  boot.kernelParams = [
    # Skip most of the initrd
    "quiet"
    "splash"
    # Faster filesystem checks
    "fastboot"
    # Skip CPU microcode update delays
    "mitigations=off"
    # Reduce kernel log level to minimize I/O
    "loglevel=3"
    "systemd.log_level=warning"
    # Skip memory test
    "memory_corruption_check=0"
    # Optimize for performance over power saving during boot
    "intel_pstate=performance"
    # Skip some hardware detection delays
    "acpi_osi=Linux"
  ];
  
  # Disable unused kernel modules that slow boot
  boot.blacklistedKernelModules = [
    # EFI pstore module (crash dump storage) - usually not needed
    "efi_pstore"
    # Disable modem manager hardware probing modules
    "qmi_wwan"
    "cdc_wdm" 
    "cdc_mbim"
    # Disable legacy hardware support
    "pcspkr"
    "iTCO_wdt"
  ];
  
  # Ultra-fast systemd configuration
  systemd.extraConfig = ''
    # Aggressive timeouts
    DefaultTimeoutStartSec=15s
    DefaultTimeoutStopSec=10s
    DefaultRestartSec=1s
    
    # Parallel startup
    DefaultDependencies=no
    
    # Reduce service manager overhead
    SystemCallArchitectures=native
    CapabilityBoundingSet=
  '';
  
  # Optimize journal for speed over persistence
  services.journald.extraConfig = ''
    # Use RAM-only storage for maximum speed
    Storage=volatile
    RuntimeMaxUse=32M
    RuntimeMaxFileSize=8M
    
    # Minimize journal overhead
    Compress=false
    RateLimitInterval=0
    RateLimitBurst=0
    
    # Reduce sync frequency
    SyncIntervalSec=60s
  '';
  
  # Disable unnecessary services for laptops without specific hardware
  systemd.services = {
    # Disable Bluetooth if not needed (can be re-enabled manually)
    bluetooth.enable = lib.mkDefault false;
    
    # Disable ModemManager (cellular modems) for most laptops
    ModemManager.enable = false;
    
    # Disable CUPS browsing service (printer discovery)
    cups-browsed.enable = false;
    
    # Disable audio setup delays
    systemd-user-sessions.enable = lib.mkDefault true;
    
    # Make thermald start after boot is complete
    thermald.wantedBy = lib.mkForce [];
  };
  
  # Aggressive filesystem optimizations
  fileSystems."/" = {
    options = lib.mkAfter [ 
      "noatime"        # Don't update access times
      "nodiratime"     # Don't update directory access times  
      "relatime"       # Only update access times if modify time is newer
      "commit=60"      # Commit every 60 seconds instead of default 5
    ];
  };
  
  # Note: Git repo setup optimization moved to separate module to avoid recursion
}