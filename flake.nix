{
  description =
    "PoliScoops helps you keep track of political news in the 27 Member States of the EU, as well as the political news from the EU Parliament and the UK.";

  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/nixos-19.09";
    flake = false;
  };

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-compat, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        docsplit-overlay = import ./nix/docsplit-overlay.nix;
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ docsplit-overlay ];
        };
        python-input = pkgs.python27.withPackages (ps:
          with ps; [
            av
            pillow
            lxml
            celery
            redis
            elasticsearch
            click
            feedparser
            facebook-sdk
            iso8601
            requests
            mock
            msgpack
            pdfminer
            dateutil
            magic
            pyopenssl
            tornado
            xlrd
            sphinx
          ]);
      in {
        devShell = pkgs.mkShell { buildInputs = with pkgs; [ python-input ]; };

        defaultPackage =
          pkgs.mkShell { buildInputs = with pkgs; [ python-input ]; };
      });
}
