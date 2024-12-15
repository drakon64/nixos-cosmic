{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-ext-ctl";
  version = "0-unstable-2024-12-15";

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "cosmic-ctl";
    rev = "9dcb348bb80ae688b7a9af24f246a1b3986d5d11";
    hash = "sha256-lT+Pihx7//LNDOa7GNiwMIBdSju/RRhRT5PqKQWqHio=";
  };

  cargoHash = "sha256-fJZQdO/+PZRD3DFAgypaI0niqMT3UwZS2hrDgMy+4Vg=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "CLI for COSMIC Desktop Environment configuration management";
    homepage = "https://github.com/cosmic-utils/cosmic-ctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-ctl";
  };
}
