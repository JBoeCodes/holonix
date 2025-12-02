{ config, lib, pkgs, ... }:

{
  # Ultra-aggressive boot speed optimizations
  # WARNING: Some of these may reduce functionality for maximum speed
  
  # Skip initrd completely where possible
  boot.initrd.enable = lib.mkDefault false;
  
  # Minimal kernel modules for fastest boot
  boot.initrd.includeDefaultModules = false;
  boot.initrd.availableKernelModules = lib.mkForce [
    # Only essential storage drivers
    "nvme" "ahci" "xhci_pci" "usb_storage" "sd_mod" "sr_mod"
    # Essential filesystem support
    "ext4" "vfat"
  ];
  
  # Skip hardware detection delays
  hardware.enableRedistributableFirmware = lib.mkForce false;
  hardware.firmware = lib.mkForce [];
  
  # Aggressive systemd optimizations
  systemd = {
    # Disable all default systemd services that aren't critical
    services = {
      systemd-random-seed.enable = false;
      systemd-update-utmp.enable = false;
      systemd-journal-catalog-update.enable = false;
      systemd-tpm2-setup.enable = false;
      systemd-tpm2-setup-early.enable = false;
      
      # Disable audit system
      audit.enable = false;
      
      # Skip polkit delays during boot
      polkit.serviceConfig.ExecStartPre = lib.mkForce "";
    };
    
    # Global service optimization
    globalEnvironment = {
      SYSTEMD_LOG_LEVEL = "warning";
    };
    
    # Ultra-fast user service startup
    user.services = {
      # Disable user services that slow down login
      at-spi-dbus-bus.enable = false;
      gnome-keyring.enable = false;
    };
  };
  
  # Minimal boot loader configuration
  boot.loader.timeout = lib.mkDefault 0;
  boot.loader.systemd-boot = {
    # Minimize boot entries
    configurationLimit = 5;
    # Don't wait for console ready
    consoleMode = "auto";
  };
  
  # Skip network setup during boot
  networking.dhcpcd.wait = "background";
  networking.networkmanager.dns = "none";  # Skip DNS setup delays
  
  # Disable unnecessary kernel features
  boot.kernel.sysctl = {
    # Reduce kernel printk overhead
    "kernel.printk" = "3 3 3 3";
    # Skip kernel address randomization delays
    "kernel.randomize_va_space" = 0;
    # Faster memory management
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
    "vm.dirty_expire_centisecs" = 1000;
    "vm.dirty_writeback_centisecs" = 1000;
    # Skip swap readahead
    "vm.page-cluster" = 0;
  };
  
  # Skip power management setup during boot
  powerManagement.cpuFreqGovernor = lib.mkForce "performance";
  
  # Disable unnecessary hardware support
  services = {
    # Skip USB monitoring
    udisks2.enable = lib.mkDefault false;
    
    # Skip location services
    geoclue2.enable = lib.mkDefault false;
  };
  
  # Disable real-time audio kit
  security.rtkit.enable = lib.mkDefault false;
  
  # Ultra-minimal environment
  environment.sessionVariables = {
    # Skip D-Bus activation delays
    DBUS_SESSION_BUS_ADDRESS = lib.mkForce "";
    # Minimize XDG overhead
    XDG_CURRENT_DESKTOP = lib.mkForce "minimal";
  };
  
  # Skip font cache generation during boot
  fonts.fontconfig.enable = lib.mkDefault false;
}