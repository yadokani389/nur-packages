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
  fetchurl,
}:

let
  version = "unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "yadokani389";
    repo = "karukan";
    rev = "f765e34d59327e040f4de77f4a8e1773e7a35a64";
    hash = "sha256-D2QE2B/NTwz2dxa+TSfKFExZbNZ2IurTmLZPMcJ4KnA=";
  };

  linderaVersion =
    (builtins.head (
      builtins.filter (p: p.name == "lindera")
        (builtins.fromTOML (builtins.readFile "${src}/Cargo.lock")).package
    )).version;

  lindera-ipadic = rec {
    filename = "mecab-ipadic-2.7.0-20250920.tar.gz";
    source = fetchurl {
      url = "https://lindera.dev/${filename}";
      hash = "sha256-p7qfZF/+cJTlauHEqB0QDfj7seKLvheSYi6XKOFi2z0=";
    };
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
      libxkbcommon
    ];

    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

    cargoBuildFlags = [
      "-p"
      "karukan-im"
    ];

    doCheck = false;

    preConfigure = ''
      export LINDERA_DICTIONARIES_PATH=$TMPDIR/lindera-cache
      mkdir -p $LINDERA_DICTIONARIES_PATH/${linderaVersion}
      cp ${lindera-ipadic.source} $LINDERA_DICTIONARIES_PATH/${linderaVersion}/${lindera-ipadic.filename}
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
