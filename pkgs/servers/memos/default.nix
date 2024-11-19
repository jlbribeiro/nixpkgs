{
  stdenv,
  lib,
  callPackage,
  fetchFromGitHub,
  buildGoModule,
  nodejs,
  pnpm,
  grpc-gateway,
  protoc-gen-go,
  protoc-gen-go-grpc,
}:

let
  inherit (import ./sources.nix { inherit fetchFromGitHub; })
    pname
    version
    src
    vendorHash
    ;

  web = callPackage ./web.nix {
    inherit
      stdenv
      fetchFromGitHub
      nodejs
      pnpm
      grpc-gateway
      protoc-gen-go
      protoc-gen-go-grpc
      ;
  };
in
buildGoModule {
  inherit
    pname
    version
    src
    vendorHash
    ;

  # check will be unable to access network in sandbox
  doCheck = false;

  # Inject frontend assets into go embed
  prePatch = ''
    rm -rf server/dist
    cp -r ${web} server/dist
  '';

  passthru = {
    inherit web;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://usememos.com";
    description = "Lightweight, self-hosted memo hub";
    maintainers = with maintainers; [
      jlbribeiro
    ];
    license = licenses.mit;
    mainProgram = "memos";
  };
}
