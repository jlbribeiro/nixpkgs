{
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-ts_proto";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "stephenh";
    repo = "ts-proto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kPiC2W+uE/v4oHNOkv3AX3xWSAAGiuvNBqZcjWe2nk0=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-Tb9b6bY8gg3dPDx8iX8Y8xB2lv4/H9qmjo5heKgG8K8=";
    patches = [
      ./package.json.patch
    ];
    postPatch = ''
      cp ${./pnpm-lock.yaml} ./pnpm-lock.yaml
    '';
  };

  patches = [
    ./package.json.patch
  ];
  postPatch = ''
    cp ${./pnpm-lock.yaml} ./pnpm-lock.yaml
  '';

  postBuild = ''
    pnpm run build
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    cp package.json "$out/lib"
    cp -r build "$out/lib"
    cp -r node_modules "$out/lib"

    mkdir -p "$out/bin"
    cat << EOF > "$out/bin/protoc-gen-ts_proto"
    #!${nodejs}/bin/node
    require('../lib/build/src/plugin')
    EOF
    chmod 0755 "$out/bin/protoc-gen-ts_proto"

    runHook postInstall
  '';

  meta = {
    # TODO: implement this
  };
})
