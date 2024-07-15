{ lib
, fetchFromGitHub
, rustPlatform
, just
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "cosmic-screenshot";
  version = "0-unstable-2024-07-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-screenshot";
    rev = "08ac28d76bade6062775cd7003f5fd610159204f";
    hash = "sha256-a7xzst+2MBchbN7vVZHmFqYxIy8OK4yBDs4NChi0Sfc=";
  };

  cargoHash = "sha256-4w8GDHBQn/46e863TuBFbfqJbap2IHdYnhz6YjPf7Gw=";

  nativeBuildInputs = [ just ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-screenshot"
  ];

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-screenshot";
    description = "Screenshot tool for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
#    maintainers = with maintainers; [ nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-screenshot";
  };
}
