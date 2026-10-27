{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      yabaiOverlay = prev: final: {
        yabai = prev.callPackage ./nix/package.nix { };
      };
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ yabaiOverlay ];
        }
      );
    in
    {
      packages = forAllSystems (system: {
        default = nixpkgsFor.${system}.yabai;
      });
    };
}
