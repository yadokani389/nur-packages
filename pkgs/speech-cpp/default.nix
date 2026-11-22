{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  makeWrapper,
  curl,
  shaderc,
  vulkan-headers,
  vulkan-loader,
}:
stdenv.mkDerivation {
  pname = "speech-cpp";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "nyosegawa";
    repo = "speech.cpp";
    rev = "cc16a71e46ee3324ca07f9df4d90ce43622ae598";
    fetchSubmodules = true;
    hash = "sha256-9U/sHJL6Pk+8m/d8uGWoNeD0rCcXJCxW0mqbMWFvJrc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
    shaderc
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    (lib.cmakeBool "GGML_NATIVE" false)
    (lib.cmakeBool "GGML_VULKAN" true)
  ];
  ninjaFlags = [ "speech-cli" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 speech "$out/bin/speech"
    wrapProgram "$out/bin/speech" --prefix PATH : ${lib.makeBinPath [ curl ]}
    runHook postInstall
  '';

  meta = {
    description = "Local speech recognition and synthesis CLI";
    homepage = "https://github.com/nyosegawa/speech.cpp";
    license = lib.licenses.mit;
    mainProgram = "speech";
    platforms = lib.platforms.linux;
  };
}
