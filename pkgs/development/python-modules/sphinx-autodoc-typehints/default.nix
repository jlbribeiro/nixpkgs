{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-vcs,
  hatchling,
  pythonOlder,
  sphinx,
  pytestCheckHook,
}:

let
  pname = "sphinx-autodoc-typehints";
  version = "2.1.1";
in

buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "sphinx_autodoc_typehints";
    inherit version;
    hash = "sha256-AHK2X1qygYwinW1sLMmTdwr1XTa7e/sWAB4vzk0UiAw=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [ sphinx ];

  nativeCheckInputs = [ pytestCheckHook ];

  # requires spobjinv, nbtyping
  doCheck = false;

  pythonImportsCheck = [ "sphinx_autodoc_typehints" ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/sphinx-autodoc-typehints/releases/tag/${version}";
    description = "Type hints (PEP 484) support for the Sphinx autodoc extension";
    homepage = "https://github.com/tox-dev/sphinx-autodoc-typehints";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
