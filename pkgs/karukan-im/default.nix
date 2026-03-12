{
  lib,
  rustPlatform,
  stdenv,
  pkg-config,
  cmake,
  openssl,
  llvmPackages,
  extra-cmake-modules,
  fcitx5,
  libxkbcommon,
  fetchFromGitHub,
}:

let
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "yadokani389";
    repo = "karukan";
    rev = "45ff128f81423cc7430bb2c9493487aa71dcc6de";
    hash = "sha256-24gq0OI8NJx2jdgvnrEQk5bx76RFrnxVbqJotO4u9Ew=";
  };

  karukan-im-rust = rustPlatform.buildRustPackage {
    pname = "karukan-im-rust";
    inherit version src;

    cargoLock.lockFile = "${src}/Cargo.lock";

    nativeBuildInputs = [
      pkg-config
      cmake
      rustPlatform.bindgenHook
      llvmPackages.libclang
    ];

    buildInputs = [
      openssl
    ];

    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

    cargoBuildFlags = [
      "-p"
      "karukan-im"
    ];

    cargoTestFlags = [
      "-p"
      "karukan-im"
    ];

    meta = with lib; {
      description = "Japanese Input Method System for Linux, Neural Kana-Kanji Conversion Engine + fcitx5 IME";
      homepage = "https://github.com/yadokani389/karukan";
      license = with licenses; [
        mit
        asl20
      ];
      platforms = platforms.linux;
    };
  };
in

stdenv.mkDerivation {
  pname = "karukan-fcitx5-addon";
  inherit version src;
  sourceRoot = "${src.name}/karukan-im/fcitx5-addon";

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
  ];

  buildInputs = [
    fcitx5
    libxkbcommon
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_program(CARGO cargo REQUIRED)' 'set(CARGO "${stdenv.shell}")' \
      --replace-fail 'set(KARUKAN_RUST_LIB "''${CMAKE_CURRENT_SOURCE_DIR}/../../target/release/libkarukan_im.so")' 'set(KARUKAN_RUST_LIB "${karukan-im-rust}/lib/libkarukan_im.so")' \
      --replace-fail '    COMMAND ''${CARGO} build --release -p karukan-im' '    COMMAND ''${CARGO} -c true'
  '';

  meta = with lib; {
    description = "Japanese Input Method System for Linux, Neural Kana-Kanji Conversion Engine + fcitx5 IME";
    homepage = "https://github.com/yadokani389/karukan";
    license = with licenses; [
      mit
      asl20
    ];
    platforms = platforms.linux;
  };
}
