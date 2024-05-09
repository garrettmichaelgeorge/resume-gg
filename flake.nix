{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys =
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in {
      packages = forEachSystem (system:
        let pkgs = pkgsFor system;
        in {
          devenv-up = self.devShells.${system}.default.config.procfileScript;
          tex = pkgs.callPackage ./tex.nix { };
          # tex = import ./tex.nix { inherit pkgs; };
          document = pkgs.callPackage ./document.nix {
            inherit pkgs self;
            tex = self.packages.${system}.tex;
          };
          default = self.packages.${system}.document;
        });

      devShells = forEachSystem (system:
        let
          pkgs = pkgsFor system;
          tex = self.packages.${system}.tex;
        in {
          default =
            pkgs.callPackage ./devenv.nix { inherit devenv inputs tex; };
        });

      checks =
        forEachSystem (system: { default = self.packages.${system}.default; });
    };
}

