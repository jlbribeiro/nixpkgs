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

  protoc-gen-ts_proto = callPackage ./protoc-gen-ts_proto { };
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
    pushd ./proto
    HOME=$TMPDIR buf generate
    popd
  '';

  installPhase = ''
    runHook preInstall

    # `buf generate` (cwd: ./proto) writes to:
    # ../docs
    # ../web/src/types/proto
    # gen
    copy_buf_path() {
      local proto_out="$1"
      local root_buf_path="proto/$proto_out"
      local out_buf_path="$out/lib/$root_buf_path"

      mkdir -p "$out_buf_path"
      cp -r "./$root_buf_path"/{.,}* "$out_buf_path"
    }

    copy_buf_path "../docs"
    copy_buf_path "../web/src/types/proto"
    copy_buf_path "gen"

    runHook postInstall
  '';

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = protobufHash;
})
