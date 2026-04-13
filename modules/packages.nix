{ pkgs, pkgs-claude, inputs, ... }:

let
  # Obsidian's CLI requires process.execPath to end in "obsidian", but NixOS
  # wraps Electron apps so the binary name is "electron". This creates a
  # patched electron where the final binary is named "obsidian".
  electronForObsidian = let
    unwrapped = pkgs.electron.unwrapped;
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
    substitute ${pkgs.electron}/bin/electron $out/bin/electron \
      --replace-fail '${unwrapped}/libexec/electron/electron' '${renamedDir}/libexec/electron/obsidian'
    chmod +x $out/bin/electron
  '';
in
{
  users.users.jboe.packages = with pkgs; [
    pkgs-claude.claude-code
    codex
    gemini-cli
    git
    opencode
    wget
    curl
    discord
    unzip
    btop
    fastfetch
    gh
    heroic
    prismlauncher
    slack
    vlc
    waveterm
    cider-2
    zoom-us
    onlyoffice-desktopeditors
    microsoft-edge
    (obsidian.override { electron = electronForObsidian; })
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
