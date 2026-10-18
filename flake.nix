{
  description = "Generador de carteles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    dependencies = [
      pkgs.coreutils
      pkgs.gawk
      pkgs.gnused
      pkgs.gnugrep
      pkgs.file
      pkgs.qrencode
      pkgs.librsvg
    ];

    fontsConf = pkgs.makeFontsConf {
      fontDirectories = [./fonts];
    };
  in {
    packages.${system}.default = pkgs.writeShellApplication {
      name = "generar";
      text = builtins.readFile ./generar.sh;
      runtimeInputs = dependencies;
      runtimeEnv.FONTCONFIG_FILE = fontsConf;
      inheritPath = false;
    };

    devShells.${system}.default = pkgs.mkShellNoCC {
      packages = dependencies;

      FONTCONFIG_FILE = fontsConf;
    };
  };
}
