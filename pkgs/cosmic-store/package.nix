{
  lib,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  flatpak,
  glib,
  just,
  openssl,
  pkg-config,
  stdenv,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-store";
  version = "1.0.0-alpha.5.1-unstable-2025-01-28";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-store";
    rev = "74ba7775fb12ec21c80a2222cdce4cd75e08efb4";
    hash = "sha256-gfWt2sokFXroLPygBWNcfgcH+h/Ox2aY4vzRHzPn4js=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8m9zEkaaM0bnA1cOVMyIFE1EdztWqkpGEuHd1fRaass=";

  nativeBuildInputs = [
    libcosmicAppHook
    just
    pkg-config
  ];
  buildInputs = [
    glib
    flatpak
    openssl
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-store"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = {
    homepage = "https://github.com/pop-os/cosmic-store";
    description = "App Store for the COSMIC Desktop Environment";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      # lilyinstarlight
    ];
    platforms = lib.platforms.linux;
    mainProgram = "cosmic-store";
  };
}
