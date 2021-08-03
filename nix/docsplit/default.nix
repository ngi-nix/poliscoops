{ bundlerApp }:
bundlerApp {
  pname = "docsplit";
  gemdir = ./.;
  exes = [ "docsplit" ];
}
