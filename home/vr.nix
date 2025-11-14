{ config, pkgs, ... }:

{
  # OpenVR runtime configuration for using Monado instead of SteamVR
  # This ensures OpenVR games use Monado as the OpenXR runtime
  xdg.configFile."openvr/openvrpaths.vrpath" = {
    text = builtins.toJSON {
      runtime = [
        "${pkgs.opencomposite}/lib/opencomposite"
      ];
      # Optionally specify config and log paths
      config = [
        "${config.home.homeDirectory}/.local/share/openvr"
      ];
      log = [
        "${config.home.homeDirectory}/.local/share/openvr"
      ];
    };
    # Make it read-only to prevent SteamVR from overwriting it
    source = pkgs.writeText "openvrpaths.vrpath" (builtins.toJSON {
      runtime = [
        "${pkgs.opencomposite}/lib/opencomposite"
      ];
      config = [
        "${config.home.homeDirectory}/.local/share/openvr"
      ];
      log = [
        "${config.home.homeDirectory}/.local/share/openvr"
      ];
    });
  };

  # Session variables for VR gaming
  home.sessionVariables = {
    # Force OpenXR runtime to use Monado instead of SteamVR
    XR_RUNTIME_JSON = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
    # Ensure OpenVR uses OpenComposite
    VR_OVERRIDE = "${pkgs.opencomposite}/lib/opencomposite";
  };

  # Create directories for OpenVR config and logs
  home.file.".local/share/openvr/.keep".text = "";
}