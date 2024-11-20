{
  stdenv,
  fetchFromGitHub,
  buf,
  grpc-gateway,
  protoc-gen-go,
  protoc-gen-go-grpc,
}:

let
  inherit (import ./sources.nix { inherit fetchFromGitHub; })
    pname
    version
    src
    protobufHash
    ;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "${pname}-protobuf";
  inherit src version;

  patches = [
    ./buf.gen.yaml.patch
  ];

  nativeBuildInputs = [
    buf
    grpc-gateway
    protoc-gen-go
    protoc-gen-go-grpc
  ];

  buildPhase = ''
    cd ./proto
    HOME=$TMPDIR buf generate
  '';

  installPhase = ''
    runHook preInstall

    # cp -r dist $out
    false

    runHook postInstall
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = protobufHash;
})
