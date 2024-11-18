{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
}:

let
  inherit (import ./sources.nix { inherit fetchFromGitHub; })
    pname
    version
    src
    vendorHash
    ;

  memos-protobuf = callPackage ./protobuf.nix { };
  web = callPackage ./web.nix {
    inherit memos-protobuf;
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
    rm -rf server/router/frontend/dist
    cp -r ${web}/share server/router/frontend/dist
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
