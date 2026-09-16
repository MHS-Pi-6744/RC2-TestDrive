# /*
{
  stdenv,
  gradle,
  makeWrapper,
  ...
}:
# */
stdenv.mkDerivation (finalAttrs: {
  pname = "robot";
  version = "2026";
  src = ./.;

  nativeBuildInputs = [
    gradle
    makeWrapper
  ];

  mitmCache = gradle.fetchDeps {
    pkg = finalAttrs.finalPackage;
    data = ./deps.json;
  };

  gradleBuildTask = "jar";
})
