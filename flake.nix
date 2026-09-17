{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    gradle2nix.url = "github:tadfisher/gradle2nix/v2";
  };
  outputs =
    {
      self,
      nixpkgs,
      systems,
      gradle2nix,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = import nixpkgs { system = "${system}"; };
        in
        {
          default = self.packages.${system}.robot.nightly;
          robot = {
            nightly = pkgs.callPackage ./default.nix {
              year = 2026; game = "Rebuilt"; robot = "TestDrivebase";
              gradle = pkgs.gradle_8;
              buildGradlePackage = gradle2nix.builders.${system}.default;
              gradleSetupHook = gradle2nix.packages.${system}.gradleSetupHook;
            };
          };
        }
      );
      devShells = eachSystem (
        system:
        let
          pkgs = import nixpkgs { system = "${system}"; };
        in
        {
          default = pkgs.mkShellNoCC { packages = with pkgs; [
            gradle2nix.packages.${system}.default
            jdk17
          ]; };
        }
      );
    };
}
