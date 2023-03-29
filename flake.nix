{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
    mkElmDerivation.url = "github:jeslie0/mkElmDerivation";
  };
  outputs = { self, nixpkgs, utils, mkElmDerivation }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          overlays = [ mkElmDerivation.overlay.${system} ];
          inherit system;
        };
        elmPackages = pkgs.elmPackages;
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [ nodejs-18_x ];
            shellHook = ''
              ROOT_DIR=$(git rev-parse --show-toplevel)
              export PATH=$ROOT_DIR/node_modules/.bin:$PATH
            '';
          };
        packages.default = pkgs.mkElmDerivation {
          pname = "7guis-elm";
          version = "0.1.0";
          src = ./.;
          outputJavaScript = true;
        };

      });
}
