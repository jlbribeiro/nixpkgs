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

  protobufHash = "sha256-Zv+81aWV6nr1HbhL4T5yMR1mNkauW5V5+tNQa0YmKdM=";
  vendorHash = "sha256-99AWzJqYRs2Mw9ByhV3c8q20l1t991rQNkLq346CWzo=";
  pnpmDepsHash = "sha256-7mXXSrJpLQKA7iI331R0FPynfCiJi+c9vkwt8AncrjE=";
}
