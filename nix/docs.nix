{ stdenv, lib }:
with lib;
stdenv.mkDerivation {
  pname = "poliscoops-doc";

  src = ../docs;

  makeFlags = "html";

  preBuild = "cd docs";

  nativeBuildInputs = [
    (python3.withPackages
      (pkgs: with pkgs; [ sphinx sphinx_rtd_theme sphinxcontrib_httpdomain ]))
  ];

  installPhase = ''
    mkdir -p $out
    cp -r _build/html $out
  '';
}
