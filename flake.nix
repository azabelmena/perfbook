{

  description = ''Nix Flake for Compiling the Perfbook:
  Is Parallel Programming Hard, And, If So, What Can You Do About It?
  https://cdn.kernel.org/pub/linux/kernel/people/paulmck/perfbook/perfbook.html
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
  };

  outputs = { self, nixpkgs }:
    let
    system = "x86_64-linux";

  pkgs = nixpkgs.legacyPackages.${system};
  in
  {

    devShells.${system} = {
      perfbook = pkgs.mkShell{
        name = "perfbook";

        nativeBuildInputs = with pkgs; [
          autoconf
          automake
          coreutils
          ghostscript
          gnuplot
          graphviz
          inkscape
          texliveFull
          transfig
        ];
      };
    };
  };
}
