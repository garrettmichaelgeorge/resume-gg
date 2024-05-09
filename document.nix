{ pkgs, tex, self }:

pkgs.stdenvNoCC.mkDerivation {
  name = "resume-gg";
  src = self;
  buildInputs = [ pkgs.coreutils tex ];
  TEXMFHOME = ".cache";
  TEXMFVAR = ".cache/texmf-var";
  buildPhase = ''
    mkdir -p "$TEXMFVAR"
    make
  '';
}
