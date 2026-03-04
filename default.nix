# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{
  pkgs ? import <nixpkgs> { },
}:

{
  # The `lib`, `modules`, and `overlays` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  wallpaper_random = pkgs.callPackage ./pkgs/wallpaper_random { };
  cargo-compete = pkgs.callPackage ./pkgs/cargo-compete { };
  fcitx5-hazkey = pkgs.callPackage ./pkgs/fcitx5-hazkey { };
  hazkey-zenzai = pkgs.callPackage ./pkgs/hazkey-zenzai { };
  karukan-im = pkgs.callPackage ./pkgs/karukan-im { };

  # vim
  lsp-endhints = pkgs.callPackage ./pkgs/lsp-endhints { };
  tiny-code-action-nvim = pkgs.callPackage ./pkgs/tiny-code-action-nvim { };
  vim-translator = pkgs.callPackage ./pkgs/vim-translator { };
}
