{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };


  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: 
      let
        syspkgs = pkgs.${system};
        pythonpkgs = syspkgs.python3Packages;
      in
      {
        default = pythonpkgs.buildPythonApplication rec {
          pname = "FlashGBX";
          version = "3.36";
          src = pythonpkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-EHg4YPJwQUvPOEQ4ktoCZk11vkin5Z8JOFFS/j5Zz7I=";
          };
          doCheck = false;
          propagatedBuildInputs = with pythonpkgs; [
            pip
            pyside6
            pillow
            pyserial
            requests
            dateutil
            setuptools
          ];
        };
      });
    };
}
