{
  description = "My personal NUR repository";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = with inputs; [
        treefmt-nix.flakeModule
        git-hooks.flakeModule
      ];

      systems = nixpkgs.lib.systems.flakeExposed;

      flake = {
        legacyPackages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (
          system:
          import ./default.nix {
            pkgs = import nixpkgs { inherit system; };
          }
        );
      };

      perSystem =
        { config, pkgs, ... }:
        let
          reservedNames = [
            "lib"
            "modules"
            "overlays"
          ];
          packages = pkgs.lib.filterAttrs (name: _: !(builtins.elem name reservedNames)) (
            import ./default.nix { inherit pkgs; }
          );
        in
        {
          packages = pkgs.lib.filterAttrs (_: v: pkgs.lib.isDerivation v) packages;

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              config.pre-commit.devShell
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
          };

          pre-commit = {
            check.enable = true;
            settings = {
              hooks = {
                treefmt.enable = true;
              };
            };
          };
        };
    };
}
