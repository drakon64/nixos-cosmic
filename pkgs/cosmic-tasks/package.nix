{ lib
, fetchFromGitHub
, libcosmicAppHook
, rustPlatform
, libsecret
, openssl
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "cosmic-tasks";
  version = "0.1.0-unstable-2024-07-11";

  src = fetchFromGitHub {
    owner = "edfloreshz";
    repo = "cosmic-tasks";
    rev = "3786d06bfcff83d1b749c08cee985ce236dc4ad8";
    hash = "sha256-IIIQdlm6BEmzoQe9uRbruUw2SUSS3z60k9J8hmcuy6g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.12.2" = "sha256-1UwgRyUe0PQrZrpS7574oNLi13fg5HpgILtZGW6JNtQ=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-cG5vnkiyDlQnbEfV2sPbmBYKv1hd3pjJrymfZb8ziKk=";
      "cosmic-config-0.1.0" = "sha256-p/1ABYyXGSr34ZC7ozu2syBjkmElA9oI2bzyWhaxKnc=";
      "cosmic-settings-daemon-0.1.0" = "sha256-+1XB7r45Uc71fLnNR4U0DUF2EB8uzKeE4HIrdvKhFXo=";
      "cosmic-text-0.12.0" = "sha256-VUUCcW5XnkmCB8cQ5t2xT70wVD5WKXEOPNgNd2xod2A=";
      "d3d12-0.19.0" = "sha256-usrxQXWLGJDjmIdw1LBXtBvX+CchZDvE8fHC0LjvhD4=";
      "glyphon-0.5.0" = "sha256-j1HrbEpUBqazWqNfJhpyjWuxYAxkvbXzRKeSouUoPWg=";
      "smithay-clipboard-0.8.0" = "sha256-pBQZ+UXo9hZ907mfpcZk+a+8pKrIWdczVvPkjT3TS8U=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
      "winit-0.29.10" = "sha256-ScTII2AzK3SC8MVeASZ9jhVWsEaGrSQ2BnApTxgfxK4=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook
  ];

  buildInputs = [
    libsecret
    openssl
    sqlite
  ];

  env.VERGEN_GIT_SHA = src.rev;

  meta = with lib; {
    homepage = "https://github.com/edfloreshz/cosmic-tasks";
    description = "Simple task management application for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
#    maintainers = with maintainers; [ lilyinstarlight ];
    platforms = platforms.linux;
    mainProgram = "cosmic-tasks";
  };
}
