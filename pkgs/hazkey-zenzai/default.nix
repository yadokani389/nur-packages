{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  vulkan-loader,
}:

stdenv.mkDerivation rec {
  pname = "hazkey-zenzai";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/7ka-Hiira/fcitx5-hazkey/releases/download/${version}/hazkey-zenzai-vulkan_${version}-1_amd64.deb";
    hash = "sha256-EY8MojyryxCWg9nHRBzAfpfm/Xbmw3o9q3IFMQPWQnw=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    vulkan-loader
    stdenv.cc.cc
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -X $src .
    runHook postUnpack
  '';

  installPhase = ''
    install -Dm755 usr/lib/x86_64-linux-gnu/hazkey/llama/libggml.so $out/lib/hazkey/llama/libggml.so
    install -Dm755 usr/lib/x86_64-linux-gnu/hazkey/llama/libggml-base.so $out/lib/hazkey/llama/libggml-base.so
    install -Dm755 usr/lib/x86_64-linux-gnu/hazkey/llama/libggml-cpu.so $out/lib/hazkey/llama/libggml-cpu.so
    install -Dm755 usr/lib/x86_64-linux-gnu/hazkey/llama/libggml-vulkan.so $out/lib/hazkey/llama/libggml-vulkan.so
    install -Dm755 usr/lib/x86_64-linux-gnu/hazkey/llama/libllama.so $out/lib/hazkey/llama/libllama.so
    cp -r usr/share $out/
  '';

  meta = with lib; {
    description = "Zenzai neural conversion module for Hazkey";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
