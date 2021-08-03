{
  description =
    "PoliScoops helps you keep track of political news in the 27 Member States of the EU, as well as the political news from the EU Parliament and the UK.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        docsplit-overlay = import ./nix/docsplit-overlay.nix { };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ docsplit-overlay ];
        };
      in { packages = { inherit (pkgs) docsplit; }; });
}
