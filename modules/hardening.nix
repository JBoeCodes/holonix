{ pkgs, lib, ... }:

{
  # Kernel hardening sysctls
  boot.kernel.sysctl = {
    "kernel.kptr_restrict" = 2;
    "kernel.dmesg_restrict" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
    "net.core.bpf_jit_harden" = 2;
    "kernel.yama.ptrace_scope" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
  };

  # Firejail sandboxing for untrusted apps
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      discord = {
        executable = "${lib.getBin pkgs.discord}/bin/discord";
      };
      telegram-desktop = {
        executable = "${lib.getBin pkgs.telegram-desktop}/bin/telegram-desktop";
      };
      vlc = {
        executable = "${lib.getBin pkgs.vlc}/bin/vlc";
      };
      qbittorrent = {
        executable = "${lib.getBin pkgs.qbittorrent}/bin/qbittorrent";
      };
    };
  };

  # Only wheel members can use sudo
  security.sudo.execWheelOnly = true;

  # Log dropped firewall connections
  networking.firewall.logRefusedConnections = true;
}
