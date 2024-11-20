{
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,

# nodejs,
# npmHooks,
}:

# TODO: remove this note
# https://github.com/NixOS/nixpkgs/pull/318015

stdenv.mkDerivation (finalAttrs: {
  pname = "protoc-gen-ts_proto";
  version = "2.3.0";
  src = fetchFromGitHub {
    owner = "stephenh";
    repo = "ts-proto";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kPiC2W+uE/v4oHNOkv3AX3xWSAAGiuvNBqZcjWe2nk0=";
  };
  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-mo0urQaWIHu00+r0Y0mL0mJ/aSe/0CihuIetTeDHEUQ=";
  };
  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
  ];
  meta = {
    # TODO: implement this
  };
})
