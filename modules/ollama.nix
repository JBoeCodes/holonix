{ pkgs, ... }:

let
  ollama-bin = pkgs.stdenv.mkDerivation rec {
    pname = "ollama";
    version = "0.20.2";

    src = pkgs.fetchurl {
      url = "https://github.com/ollama/ollama/releases/download/v${version}/ollama-linux-amd64.tar.zst";
      hash = "sha256-qYl6rKEp3uWM4amHgj1CVPlo/uuJGsyFDn8g/7BCYlE=";
    };

    nativeBuildInputs = [ pkgs.zstd pkgs.autoPatchelfHook ];

    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    sourceRoot = ".";

    unpackPhase = ''
      zstd -d $src -o ollama.tar
      tar xf ollama.tar
    '';

    installPhase = ''
      mkdir -p $out
      cp -r bin $out/
      cp -r lib $out/
    '';

    # Don't patch the bundled CUDA libs — they're loaded by dlopen
    autoPatchelfIgnoreMissingDeps = [ "libcuda.so.1" ];

    meta = with pkgs.lib; {
      description = "Ollama - run LLMs locally (prebuilt binary)";
      homepage = "https://ollama.com";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = "ollama";
    };
  };
in
{
  services.ollama = {
    enable = true;
    package = ollama-bin;
  };
}
