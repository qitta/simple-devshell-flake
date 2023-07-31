{ buildGoModule,... }:
buildGoModule {
  pname = "app1";
  version = "v1.0";
  src = ./src;
  doCheck = false;
  vendorSha256 = "sha256-GiEzSTuvHJPjLrhHUQz/ZCwshPesWbw0siiJSfHzgec=";

}
