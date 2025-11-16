{ config, lib, pkgs, ... }:

{
  # Power management for laptops
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  
  # Disable power-profiles-daemon in favor of TLP
  services.power-profiles-daemon.enable = false;
  
  # TLP for battery optimization
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # Intel CPU energy/performance policies
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
      
      # Min/Max CPU frequency
      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 80;
      
      # Turbo boost settings
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      
      # Runtime power management for PCI(e) devices
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      
      # Battery charge thresholds (if supported by hardware)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  
  # Thermald for thermal management
  services.thermald.enable = true;
  
  # Enable powertop auto-tune
  systemd.services.powertop = {
    enable = true;
    description = "Powertop tunings";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
      RemainAfterExit = "yes";
    };
  };
}