{
  fetchFromGitHub,
}:
rec {
  pname = "memos";
  version = "0.23.0-rc.1";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-47zb3mX4RLh4bSTFeDd9NPz3XQurBN9nIuCc/AaamBo=";
  };

  protobufHash = "sha256-lKDiv1+4IFd0tHKVYY+IlRI5YZrd2nyXtQbZVBfkMpw=";
  vendorHash = "sha256-99AWzJqYRs2Mw9ByhV3c8q20l1t991rQNkLq346CWzo=";
  pnpmDepsHash = "sha256-Sbe4zhqiiwzKNi/olo3psHtQgVx28Z1BgmX7q/frRFk=";
}
