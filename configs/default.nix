{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "heimdall-dev-configs";
  src = ./src;
  # move all configs to heimdall-dev-configs output
  installPhase = ''
    mkdir $out
    cp -rv $src/* $out
  '';
}
