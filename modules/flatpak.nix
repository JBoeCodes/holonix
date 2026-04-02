{ ... }:

{
  services.flatpak = {
    enable = true;

    packages = [
      "org.vinegarhq.Sober"
    ];

    update.onActivation = true;
  };

  xdg.portal.enable = true;
}
