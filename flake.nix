{
  description =
    "PoliScoops helps you keep track of political news in the 27 Member States of the EU, as well as the political news from the EU Parliament and the UK.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in { docs = import nixpkgs.lib.callPackage ./nix/docs.nix { }; });
}
