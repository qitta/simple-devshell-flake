# This file shows some basic approaches how you can include scripts (bash,
# python) in your developer shell with nix functions.
{
  pkgs,
  configs,
  ...
}: {
  # INFO: Inline shell scripts, there are better examples that are using the
  # writeShellApplication function, just see below
  script1 = pkgs.writeScriptBin "script1" ''
    #!/usr/bin/env bash
    echo "Runing script1 that was define inline in scripts/default.nix"
  '';

  script2 = pkgs.writeShellApplication {
    name = "script2";
    # INFO: You can write here a shell script inline or add it by reading a
    # file with buildints.readFile, see for more:
    # https://nixos.org/manual/nix/stable/language/builtins.html
    text = builtins.readFile ./context2/script2.sh;
  };

  # INFO: writers.writePython3Bin adds the python3 shebang for you
  # also you can write the code inline like with writeScriptBin
  # You can open interactive nix shell with `nix repl` on the commandline,
  # loading all nix packages into scope with `:l <nixpkgs>` and then you can
  # pkgs.writers.<tab>  whats available else
  script3 =
    pkgs.writers.writePython3Bin "script3" {
      flakeIgnore = ["E501"];
    }
    ./context1/script3.py;

  # INFO: Never forget chuck norris facts
  # The fact script is using a config from ${configs}/facts which is defined
  # under configs in this repo
  # ${pkgs.tool}/bin/tool is a way to have dependencies/tools direclty in your path,
  # it gets expanded to /nix/store/path-to-tool, see e.g. this script in the nix store
  # after you loaded the nix shell.
  # NOTE:
  # $ whereis fact
  # fact in /nix/store/63msjz3qihdrxz1x76kg2k0vqj151yf6-fact/bin/fact
  # cat /nix/store/63msjz3qihdrxz1x76kg2k0vqj151yf6-fact/bin/fact <- here is the content of your script
  # QUOTE=$(cat /nix/store/1gnf4lnph129kr3vfc77g0kcx16rp0vj-heimdall-dev-configs/facts | /nix/store/c2bq8xsayc90s33fd5xbm1vh5lrmwcfq-coreutils-9.3/bin/shuf | /nix/store/c2bq8xsayc90s33fd5xbm1vh5lrmwcfq-coreutils-9.3/bin/tail -n 1 )
  # echo $(gum style --foreground 4 Fact:) $(gum style --foreground 2 "$QUOTE" ) | fold -s -w 75
  fact = pkgs.writeScriptBin "fact" ''
    QUOTE=$(cat ${configs}/facts | ${pkgs.coreutils}/bin/shuf | ${pkgs.coreutils}/bin/tail -n 1 )
    echo $(gum style --foreground 4 Fact:) $(gum style --foreground 2 "$QUOTE" ) | fold -s -w 75
  '';
}
