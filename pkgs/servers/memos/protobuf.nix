{
  stdenv,
  callPackage,
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

  protoc-gen-ts_proto = callPackage ./protoc-gen-ts_proto.nix { };
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
    protoc-gen-ts_proto
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
