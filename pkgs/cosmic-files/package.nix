{ lib
, fetchFromGitHub
, rustPlatform
, libcosmicAppHook
, stdenv
, glib
, just
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-files";
  version = "0-unstable-2024-07-15";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-files";
    rev = "86d647512e02b832c68c34a8a4f96c0ecb927cb6";
    hash = "sha256-kiPHXtEXu3Ofl4sVT9cRfxxucx1liRWlB0SnXuDK9y8=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-client-toolkit-0.1.0" = "sha256-1XtyEvednEMN4MApxTQid4eed19dEN5ZBDt/XRjuda0=";
      "cosmic-config-0.1.0" = "sha256-wvt9PGD6rezDTC0/IDC4LEPlm8QWTFBEinjvY7HfLXs=";
      "cosmic-text-0.12.0" = "sha256-VUUCcW5XnkmCB8cQ5t2xT70wVD5WKXEOPNgNd2xod2A=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "fs_extra-1.3.0" = "sha256-ftg5oanoqhipPnbUsqnA4aZcyHqn9XsINJdrStIPLoE=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "trash-5.0.0" = "sha256-6cMo2GtMJjU+fbehlsGNmj3LbzSP+vOjA4en3OgmZ54=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [ libcosmicAppHook just ];
  buildInputs = [ glib ];

  dontUseJustBuild = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-files"
  ];

  env.VERGEN_GIT_SHA = src.rev;

  # TODO: remove when <https://github.com/pop-os/cosmic-files/pull/103#issuecomment-2051661109> is fixed
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-files";
    description = "File Manager for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
#    maintainers = with maintainers; [ ahoneybun nyanbinary lilyinstarlight ];
    platforms = platforms.linux;
  };
}
