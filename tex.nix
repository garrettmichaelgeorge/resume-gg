{ pkgs }:

let
  texlivePkgs = { inherit (pkgs.texlive) scheme-medium latex-bin latexmk; };
  cpanPkgs = {
    inherit (pkgs.texlive)
      bookmark enumitem environ etoolbox fontawesome5 fontspec hyperref ifmtarg
      parskip ragged2e roboto setspace sourcesanspro tcolorbox tikzfill
      unicode-math xcolor xifthen xstring;
  };
in
pkgs.texlive.combine texlivePkgs // cpanPkgs
