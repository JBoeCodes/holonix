{ pkgs, inputs, ... }:

let
  # Obsidian's CLI requires process.execPath to end in "obsidian", but NixOS
  # wraps Electron apps so the binary name is "electron". This creates a
  # patched electron where the final binary is named "obsidian".
  electronForObsidian = let
    baseElectron = pkgs.electron_39;
    unwrapped = baseElectron.unwrapped;
    renamedDir = pkgs.runCommand "electron-obsidian-unwrapped" {} ''
      mkdir -p $out/libexec/electron
      for f in ${unwrapped}/libexec/electron/*; do
        ln -s "$f" "$out/libexec/electron/"
      done
      rm $out/libexec/electron/electron
      ln ${unwrapped}/libexec/electron/electron $out/libexec/electron/obsidian \
        || cp ${unwrapped}/libexec/electron/electron $out/libexec/electron/obsidian
    '';
  in pkgs.runCommand "electron-for-obsidian" {} ''
    mkdir -p $out/bin
    substitute ${baseElectron}/bin/electron $out/bin/electron \
      --replace-fail '${unwrapped}/libexec/electron/electron' '${renamedDir}/libexec/electron/obsidian'
    chmod +x $out/bin/electron
  '';
in
{
  users.users.jboe.packages = with pkgs; [
    claude-code
    codex
    gemini-cli
    (goose-cli.overrideAttrs (_: { doCheck = false; }))
    git
    opencode
    wget
    curl
    discord
    unzip
    btop
    fastfetch
    gh
    google-cloud-sdk
    heroic
    prismlauncher
    eden
    slack
    vlc
    waveterm
    cider-2
    zoom-us
    onlyoffice-desktopeditors
    microsoft-edge
    (obsidian.override { electron_39 = electronForObsidian; })
    qbittorrent
    telegram-desktop
    gimp
    localsend
    railway
    obs-studio
    ani-cli
    fzf
    ripgrep
    rclone
    eza
    bat
    zoxide
    fd
    duf
    lazygit
    uv
    cmatrix
    pipes-rs
    cbonsai
    sox
    yazi
    inputs.zen-browser.packages.${pkgs.system}.default
    pamixer
    (pkgs.runCommand "parsec-nvidia-wrapped" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin $out/share
      cp -r ${parsec-bin}/share/* $out/share/ 2>/dev/null || true
      makeWrapper ${parsec-bin}/bin/parsecd $out/bin/parsecd \
        --prefix LD_LIBRARY_PATH : "/run/opengl-driver/lib"
    '')
  ];

}
