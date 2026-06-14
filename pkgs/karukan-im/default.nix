{
  lib,
  rustPlatform,
  stdenv,
  pkg-config,
  cmake,
  shaderc,
  llvmPackages,
  openssl,
  vulkan-headers,
  vulkan-loader,
  libxkbcommon,
  kdePackages,
  fcitx5,
  fetchFromGitHub,
  fetchurl,
  vulkanSupport ? false,
}:

let
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "yadokani389";
    repo = "karukan";
    rev = "3ea54033f2ab07878c0ab494154bcf449b5d7afe";
    hash = "sha256-V/IIC1jNtbwTXkOeWe04TYHO5V6miDNhKVFds6AdED4=";
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

    cargoHash = "sha256-14PvVw4iiqVqHvM04JnMwCPnMzPSGbmKrpJQfpyRn74=";

    nativeBuildInputs = [
      pkg-config
      cmake
      rustPlatform.bindgenHook
      llvmPackages.libclang
    ]
    ++ lib.optional vulkanSupport shaderc;

    buildInputs = [
      openssl
      libxkbcommon
    ]
    ++ lib.optionals vulkanSupport [
      vulkan-headers
      vulkan-loader
    ];

    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

    cargoBuildFlags = [
      "-p"
      "karukan-im"
    ];

    buildFeatures = lib.optional vulkanSupport "gpu-vulkan";

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
    kdePackages.extra-cmake-modules
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
