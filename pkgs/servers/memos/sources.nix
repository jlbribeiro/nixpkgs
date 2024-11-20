{
  fetchFromGitHub,
}:
rec {
  pname = "memos";
  version = "0.22.5";

  src = fetchFromGitHub {
    owner = "usememos";
    repo = "memos";
    rev = "v${version}";
    hash = "sha256-tEI59pkpmSuQlvg8zB8QnDM30GlMbr4ZWKPr/3NL/Uk=";
  };

  protobufHash = "sha256-q08jSX7jZO3Y4gn0dxq1NYLEfCUWVcUwmNfqT52AU/M=";
  vendorHash = "sha256-q38jSX7jZO3Y4gn7dxq4NYLEfCUWVcUwmNfqT52AU/M=";
  pnpmDepsHash = "sha256-jJMVSBV3XPZYbpPczARUlxucbVwsfcyNlAQ8OodxiT8=";
}
