{ config, pkgs, ... }:

{
  # OpenVR runtime configuration for using Monado instead of SteamVR
  # This ensures OpenVR games use Monado as the OpenXR runtime
  # NOTE: Removed read-only constraint to allow SteamVR to write to this file

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