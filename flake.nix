{
  # inspired by: https://serokell.io/blog/practical-nix-flakes#packaging-existing-applications
  description = "A Hello World in Haskell with a dependency and a devShell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    # devshell.url = "github:numtide/devshell";
     flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils,  pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [  ];
        };


        t = pkgs.lib.trivial;
        hl = pkgs.haskell.lib;

        name = "haskell-hello";

        wireHook =          drv: drv.overrideAttrs (oldAttrs: rec {
                inherit (self.checks.${system}.pre-commit-check) shellHook;
              });
        project = devTools: # [1]
          let addBuildTools = (t.flip hl.addBuildTools) devTools;
          in pkgs.haskellPackages.developPackage {
            root =
              nixpkgs.lib.sourceFilesBySuffices ./. [ ".cabal" ".hs" "package.yaml" ];
            name = name;
            returnShellEnv = !(devTools == [ ]); # [2]

            modifier = (t.flip t.pipe) [
              wireHook
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
checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
                ormolu.enable = true;
            };
          };
        };
        defaultPackage = self.packages.${system}.pkg;
# devShell = pkgs.devshell.mkShell {
#   inherit name;
#           imports = [ (pkgs.devshell.extraModulesDir + "/git/hooks.nix") ];
#           git.hooks.enable = true;
#           git.hooks.pre-commit.text = "${pkgs.treefmt}/bin/treefmt";
#           packages = [ (project [] ) pkgs.treefmt pkgs.cabal2nix pkgs.nixfmt ];
#         };
        devShell = project (with pkgs.haskellPackages; [ # [4]
          cabal-fmt
          cabal-install
          haskell-language-server
          hlint
          ormolu
        ]);

      });
}
