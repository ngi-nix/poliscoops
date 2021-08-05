final: prev: {
  docsplit = prev.pkgs.callPackage ./docsplit/default.nix {
    inherit (prev.pkgs) bundlerApp;
  };
}
