{ pkgs, tex, self }:

pkgs.stdenvNoCC.mkDerivation {
  name = "resume-gg";
  src = self;
  buildInputs = [ pkgs.coreutils tex ];
}
