{
  # inspired by: https://serokell.io/blog/practical-nix-flakes#packaging-existing-applications
  description = "A Hello World in Haskell with a dependency and a devShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    devshell.url = "github:numtide/devshell";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay  ];
        };


        t = pkgs.lib.trivial;
        hl = pkgs.haskell.lib;

        name = "haskell-hello";

        project = devTools: # [1]
          let addBuildTools = (t.flip hl.addBuildTools) devTools;
          in pkgs.haskellPackages.developPackage {
            root =
              nixpkgs.lib.sourceFilesBySuffices ./. [ ".cabal" ".hs" "package.yaml" ];
            name = name;
            returnShellEnv = !(devTools == [ ]); # [2]

            modifier = (t.flip t.pipe) [
              addBuildTools
              hl.dontHaddock
              hl.enableStaticLibraries
              hl.justStaticExecutables
              hl.disableLibraryProfiling
              hl.disableExecutableProfiling
            ];
          };

      in {
        packages.pkg = project [ ]; # [3]

        defaultPackage = self.packages.${system}.pkg;

        devShell = project (with pkgs.haskellPackages; [ # [4]
          cabal-fmt
          cabal-install
          haskell-language-server
          hlint
          ormolu
          pkgs.treefmt
        ]);
      });
}
