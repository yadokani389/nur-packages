{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  fcitx5,
  vulkan-loader,
  kdePackages,
  protobuf_33,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-hazkey";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/7ka-Hiira/fcitx5-hazkey/releases/download/${version}/fcitx5-hazkey-${version}-x86_64.tar.gz";
    hash = "sha256-XIY7r0FK32cy+ImwyPPOkxrK5pX/rNHetKL4MH/MNpI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    fcitx5
    vulkan-loader
    kdePackages.qtbase
    protobuf_33
  ];

  patchPhase = ''
    sed -i "s|/usr/lib/x86_64-linux-gnu/hazkey/hazkey-server|$out/bin/.hazkey-server-wrapped|" bin/hazkey-server
  '';

  installPhase = ''
    install -Dm755 lib/x86_64-linux-gnu/hazkey/llama-stub/libllama.so $out/lib/hazkey/llama-stub/libllama.so
    install -Dm755 bin/hazkey-server $out/bin/hazkey-server
    install -Dm755 lib/x86_64-linux-gnu/hazkey/hazkey-server $out/bin/.hazkey-server-wrapped
    install -Dm755 lib/x86_64-linux-gnu/hazkey/hazkey-settings $out/bin/hazkey-settings
    install -Dm755 lib/x86_64-linux-gnu/fcitx5/fcitx5-hazkey.so $out/lib/fcitx5/fcitx5-hazkey.so
    cp -r share $out/
  '';

  meta = with lib; {
    description = "Japanese input method for fcitx5, powered by azooKey engine";
    homepage = "https://github.com/7ka-Hiira/fcitx5-hazkey";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
