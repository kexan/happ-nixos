{
  description = "Happ VPN/Proxy desktop client and background TUN daemon";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.callPackage ./happ.nix {};
          happ-desktop = self.packages.${system}.default;
        });

      nixosModules = {
        default = import ./happ-module.nix;
        happ = self.nixosModules.default;
      };
    };
}
