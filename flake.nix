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

    perfbook-1c = "perfbook-1c.pdf";
    perfbook-eb = "perfbook-eb.pdf";
    perfbook-hb = "perfbook-hb.pdf";

    home = "~/perfbook/";

  pkgs = nixpkgs.legacyPackages.${system};
  in
  {

    devShells.${system} = {
      build-perfbook = pkgs.mkShell{
        name = "build-perfbook";

        PERFBOOK_PAPER = "A4";

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

        shellHook = ''
          echo "Building Perfbook!"
          make

          echo "Building ${perfbook-1c}!"
          make ${perfbook-1c}

          echo "Building ${perfbook-eb}!"
          make ${perfbook-eb}

          echo "Building ${perfbook-hb}!"
          make ${perfbook-hb}

          echo "Cleaning build environment!"
          make clean

          echo "Exiting!"
          exit
        '';
      };
    };

    clean-perfbook = pkgs.mkShell{
      name = "clean-perfbook";

      shellHook = ''
        echo "Cleaning PDF files!"
        rm *.pdf

        echo "Cleaning build environment!"
        make clean

        echo "Exiting!"
        exit
      '';
    };

    help-perfbook = pkgs.mkShell{
      name = "help-perfbook";

      shellHook = ''
        echo "Outputing help!"
        make help-full

        echo "Make sure to clean build environment with:"
        echo "nix develop .#clean-perfbook"

        echo "Exiting!"
        exit
      '';
    };

    update-perfbook = pkgs.mkShell{
      name = "update-perfbook";

      shellHook = ''
        echo "Updating perfbook!"
        echo "Fetching Upstream!"
        git fetch upstream

        echo "Merging Upstream!"
        git merge upstream/master

        echo "Pushing Upstream!"
        git push -u origin main

        echo "Exiting!"
        exit
      '';
    };

    mkshell = pkgs.mkShell{
      name = "perfbook";

        PERFBOOK_PAPER = "A4";

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

        shellHook = ''
          echo "Entering shell!"
          echo "Using bash!"

          echo "Entering build directory!"
          cd ${home}
        '';
    };

    help = pkgs.mkShell{
      name = "help";

      shellHook = ''
        echo "Run:"
        echo "nix develop .#<option>"

        echo "Options:"
        echo "build-perfbook -- builds the perfbook PDF on specific targets (see help-perfbook for targets)."
        echo "clean-perfbook -- removes build targets and cleans perfbook build environment."
        echo "update-perfbook -- updates the perfbook git repository from upstream."
        echo "mkshell -- Enter dev shell for manual interaction with build environment."
        echo "help-perfbook -- prints help information for building perfbook."
        echo "help -- prints help information for nix flake."

        echo "Exiting!"
        exit
      '';
    };
  };
}
