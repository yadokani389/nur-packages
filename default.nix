{
  pkgs ? import <nixpkgs> { },
}:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  wallpaper_random = pkgs.callPackage ./pkgs/wallpaper_random { };
  wf-recorder-toggle = pkgs.callPackage ./pkgs/wf-recorder-toggle { };
  cargo-compete = pkgs.callPackage ./pkgs/cargo-compete { };
  sptlrx-ex = pkgs.callPackage ./pkgs/sptlrx-ex { };
  textlint-plugin-typst = pkgs.callPackage ./pkgs/textlint-plugin-typst { };
  pahcer = pkgs.callPackage ./pkgs/pahcer { };
  ts-send = pkgs.callPackage ./pkgs/ts-send { };

  # vim
  lsp-endhints = pkgs.callPackage ./pkgs/lsp-endhints { };
  tiny-code-action-nvim = pkgs.callPackage ./pkgs/tiny-code-action-nvim { };
  vim-translator = pkgs.callPackage ./pkgs/vim-translator { };
}
