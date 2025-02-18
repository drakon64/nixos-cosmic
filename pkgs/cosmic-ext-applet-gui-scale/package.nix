{
  lib,
  fetchFromGitHub,
  libcosmicAppHook,
  rustPlatform,
  just,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-applet-gui-scale";
  version = "2.0.0-unstable-2025-01-24";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "gui-scale-applet";
    rev = "46e3106a00e09aa83455a4ee29d4728f9f4d08e6";
    hash = "sha256-T3VGhJaGDl0/6C72YAp6SIfSXQl7P1RBneSaJ4N9UxU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-m8Ap3aXnjwQ14boE+e3zrYSOimLK+NXjA+KO7uwXktQ=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "./target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-ext-applet-gui-scale"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/cosmic-utils/gui-scale";
    description = "COSMIC applet for Tailscale";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-ext-applet-gui-scale";
  };
}
