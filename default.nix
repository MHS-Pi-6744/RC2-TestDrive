{
  gradle,
  buildGradlePackage,
  gradleSetupHook,
  # metadata info
  year ? 2025,
  game ? "Offseason",
  robot ? "Unknown",
  ...
}:

let
  # year - 2024 = what number should be put at the end of RC. (ex: year = 2026 -> RC2)
  pname = "RC${toString (year - 2024)}-${game}";
  version = robot;
in
buildGradlePackage {
  inherit gradle version pname;
  src = ./.;
  lockFile = ./gradle.lock;

  nativeBuildInputs = [
    gradleSetupHook
  ];

  gradleFlags = [
    "--offline"
  ];
  gradleBuildFlags = [ "build" ];
  gradleInstallFlags = [ "deploy" ];
  # nix can have an output as a treat
  postInstall = "touch $out";
}
