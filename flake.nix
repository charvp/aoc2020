{
  description = "Advent of Code 2020";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils/master";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = builtins.foldl' (a: b: a // b) { } (map (day: import day pkgs.writeText) [
          ./day01
          ./day02
          ./day03
          ./day04
          ./day05
        ]);
      }
    );
}
