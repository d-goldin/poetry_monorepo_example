# This is just for nix/os, to get basic local dev dependencies
# going...

with import <nixpkgs> { };

let
  venvDir = "./.venv";
  pythonPackages = python3Packages;
in pkgs.mkShell rec {
  name = "impurePythonEnv";
  buildInputs = [
    gnumake
    pythonPackages.python
    pythonPackages.pip
    pythonPackages.cffi
  ];

  shellHook = ''
    SOURCE_DATE_EPOCH=$(date +%s)

    if [ -d "${venvDir}" ]; then
      echo "Skipping venv creation, '${venvDir}' already exists"
    else
      echo "Creating new venv environment in path: '${venvDir}'"
      ${pythonPackages.python.interpreter} -m venv "${venvDir}"
    fi

    source "${venvDir}/bin/activate"
    pip install "poetry==1.0.5"
  '';
}
