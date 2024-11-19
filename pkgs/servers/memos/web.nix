{
  stdenv,
  fetchFromGitHub,
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
    pnpmDepsHash
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${pname}-web";
  inherit src version;

  sourceRoot = "${finalAttrs.src.name}/web";

  patches = [
    ./buf.gen.yaml.patch
  ];

  nativeBuildInputs = [
    nodejs
    pnpm.configHook

    grpc-gateway
    protoc-gen-go
    protoc-gen-go-grpc
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = pnpmDepsHash;
  };

  postBuild = ''
    pnpm run build
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
})
