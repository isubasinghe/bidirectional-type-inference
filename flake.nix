{
  description = "Bidirectional type inference tutorial and example implementation";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          ghc = pkgs.haskellPackages.ghcWithPackages (haskellPackages: [
            haskellPackages.containers
          ]);
          tex = pkgs.texliveSmall.withPackages (texPackages: [
            texPackages.backnaur
            texPackages.cm-super
            texPackages.lazylist
            texPackages.newtx
            texPackages.polytable
            texPackages.stmaryrd
          ]);
        in
        rec {
          tinfer = pkgs.stdenvNoCC.mkDerivation {
            pname = "tinfer";
            version = "0.1.0";
            src = self;

            nativeBuildInputs = [ ghc ];

            dontConfigure = true;

            buildPhase = ''
              runHook preBuild
              mkdir build
              ghc -outputdir build -o build/tinfer Main.hs Eval.lhs
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              install -Dm755 build/tinfer "$out/bin/tinfer"
              runHook postInstall
            '';
          };

          paper = pkgs.stdenvNoCC.mkDerivation {
            pname = "bidirectional-type-inference-paper";
            version = "0.1.0";
            src = self;

            nativeBuildInputs = [
              pkgs.lhs2tex
              tex
            ];

            dontConfigure = true;

            buildPhase = ''
              runHook preBuild
              lhs2TeX Eval.lhs > eval.tex
              pdflatex -interaction=nonstopmode -halt-on-error eval.tex
              pdflatex -interaction=nonstopmode -halt-on-error eval.tex
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              install -Dm644 eval.pdf \
                "$out/share/doc/bidirectional-type-inference/eval.pdf"
              runHook postInstall
            '';
          };

          default = pkgs.symlinkJoin {
            name = "bidirectional-type-inference-0.1.0";
            paths = [
              tinfer
              paper
            ];
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.tinfer}/bin/tinfer";
        };
      });

      checks = forAllSystems (system: {
        inherit (self.packages.${system}) paper tinfer;
      });

      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          ghc = pkgs.haskellPackages.ghcWithPackages (haskellPackages: [
            haskellPackages.containers
          ]);
          tex = pkgs.texliveSmall.withPackages (texPackages: [
            texPackages.backnaur
            texPackages.cm-super
            texPackages.lazylist
            texPackages.newtx
            texPackages.polytable
            texPackages.stmaryrd
          ]);
        in
        {
          default = pkgs.mkShell {
            packages = [
              ghc
              pkgs.gnumake
              pkgs.lhs2tex
              tex
            ];
          };
        }
      );
    };
}
