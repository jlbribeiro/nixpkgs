{
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
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

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
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
