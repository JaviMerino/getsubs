{
  description = "getsubs - download subtitles of videos";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;

        # Define webvtt-py package since it's not in nixpkgs
        webvtt-py = pythonPackages.buildPythonPackage rec {
          pname = "webvtt-py";
          version = "0.5.1";
          format = "setuptools";

          src = pkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-IEDdMlJ33a3B4MbMZsvEodm2tJskxXoMM2Q3TD6KPcE=";
          };

          propagatedBuildInputs = with pythonPackages; [
            docopt
          ];

          # Tests require network access
          doCheck = false;

          meta = with pkgs.lib; {
            description = "WebVTT reader, writer and segmenter";
            homepage = "https://github.com/glut23/webvtt-py";
            license = licenses.mit;
          };
        };
      in
      {
        packages = {
          default = pythonPackages.buildPythonApplication {
            pname = "getsubs";
            version = "0.1.0";
            format = "pyproject";

            src = ./.;

            nativeBuildInputs = with pythonPackages; [
              setuptools
              wheel
            ];

            propagatedBuildInputs = with pythonPackages; [
              webvtt-py
              yt-dlp
            ];

            meta = with pkgs.lib; {
              description = "getsubs - download subtitles of videos";
              license = licenses.mit;
              maintainers = [ ];
            };
          };
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            pythonPackages.pip
            pythonPackages.setuptools
            pythonPackages.wheel

            # Dependencies
            webvtt-py
            pythonPackages.yt-dlp

            # Development tools
            pythonPackages.black
            pythonPackages.ruff
            pythonPackages.mypy
            nixfmt-rfc-style
            shellcheck
            mdl
          ];

          shellHook = ''
            echo "getsubs development environment"
          '';
        };
      }
    ))
    // {
      overlays.default = final: prev: {
        getsubs = self.packages.${prev.stdenv.hostPlatform.system}.default;
      };
    };
}
