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
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
        pythonPackages = python.pkgs;
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
              # Add Python dependencies here
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

            # Development tools
            pythonPackages.black
            pythonPackages.ruff
            pythonPackages.mypy
            nixfmt-rfc-style
            shellcheck
          ];

          shellHook = ''
            echo "getsubs development environment"
          '';
        };
      }
    );
}
