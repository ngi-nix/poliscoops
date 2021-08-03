{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  name = "poliscoops-doc";

  src = ../docs;

  makeFlags = "html";

  preBuild = "cd docs";

  nativeBuildInputs = [
    (pkgs.python3.withPackages
      (pkgs: with pkgs; [ sphinx sphinx_rtd_theme sphinxcontrib_httpdomain ]))
  ];

  installPhase = ''
    mkdir -p $out
    cp -r _build/html $out
  '';
}
