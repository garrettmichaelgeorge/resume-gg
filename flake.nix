{
  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = { self, nixpkgs, devenv, systems, ... } @ inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packages = self.packages.${system};
        in
        {
          devenv-up = self.devShells.${system}.default.config.procfileScript;
          tex = pkgs.texlive.combine {
            inherit (pkgs.texlive)
              scheme-medium
              latex-bin
              latexmk
              # CPAN packages
              bookmark
              enumitem
              environ
              etoolbox
              fontawesome5
              fontspec
              hyperref
              ifmtarg
              parskip
              ragged2e
              roboto
              setspace
              sourcesanspro
              tcolorbox
              tikzfill
              unicode-math
              xcolor
              xifthen
              xstring
              ;
          };
          document =
            pkgs.stdenvNoCC.mkDerivation {
              name = "resume-gg";
              src = ./.;
              buildInputs = [
                pkgs.coreutils
                packages.tex
              ];
            };
          default = packages.document;
        });

      devShells = forEachSystem
        (system:
          let
            pkgs = nixpkgs.legacyPackages.${system};
            tex = self.packages.${system}.tex;
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  # https://devenv.sh/reference/options/
                  packages = [
                    tex
                  ];

                  enterShell = ''
                    echo "Hello, devenv"
                  '';

                  processes.latexmk-watch.exec = "make watch";
                }
              ];
            };
          });
    };
}
