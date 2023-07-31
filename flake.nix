{
  description = "A basic devShell for heimdall";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"] (
      system: let
        pkgs = import nixpkgs {inherit system;};

        # INFO: Configs can go here so you can make them also available using
        # the nix store. In the `fact` script in scripts/default.nix that is
        # defined inline you can see how a `config file` is used.
        configs = import ./configs {inherit pkgs;};
        scripts = import ./scripts {inherit self pkgs configs;};

        # Add custom tools like e.g. a go app in this example
        # There are builders for all other languages.
        #
        # How to package things can is described in the docs, alternatively
        # check github/nixpkgs (folder: pkgs/...). Here you will find all the
        # expressions for all packages available in the nixpkgs repository
        app1 = pkgs.callPackage ./pkgs/app1 {};

        # E.g. custom script that you want to have available in your developer shell
        userScripts = with scripts; [script1 script2 script3 fact];

        # E.g. build dependencies to build you project
        buildDependencies = with pkgs; [go_1_20 govulncheck revive golangci-lint];

        # Other utilities you want in your environment
        utilities = with pkgs; [ fzf zip app1 ];
      in {
        devShells = {
          ci = pkgs.mkShell {
            buildInputs = buildDependencies;
          };

          default = pkgs.mkShell {
            name = "the-name-of-the-shell";

            # All packages that you want to have available in your dev shell
            buildInputs = utilities ++ userScripts ++ buildDependencies;

            # INFO: The shellHook runs everytime you enter the shell
            shellHook = ''
              gum style --foreground 120 --border-foreground 111 --border rounded \
              --align center --width 55  --margin "1 2" --padding "1 2"  'Simple Developer Environment 😺'

              echo "General:"
              echo "  $(gum style --foreground 120 ✎) Run $(gum style --foreground 212 script1) to run a beautiful bash script."
              echo "  $(gum style --foreground 120 ✎) Run $(gum style --foreground 212 script2) to run a beautiful bash script."
              echo "  $(gum style --foreground 120 ✎) Run $(gum style --foreground 212 script3) to run a beautiful python script."
              echo ""

              # Run the fact script
              fact
            '';
          };
        };

        # When you run `nix fmt` the alejandra formatter is used to format the
        # nix files in this repository
        formatter = pkgs.alejandra;
      }
    );
}
