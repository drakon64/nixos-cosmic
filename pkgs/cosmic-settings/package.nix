{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libcosmicAppHook,
  cmake,
  cosmic-randr,
  expat,
  fontconfig,
  freetype,
  just,
  libinput,
  pipewire,
  pkg-config,
  pulseaudio,
  udev,
  util-linux,
  xkeyboard_config,
  nix-update-script,
}:

let
  libcosmicAppHook' = (libcosmicAppHook.__spliced.buildHost or libcosmicAppHook).override {
    includeSettings = false;
  };
in

rustPlatform.buildRustPackage {
  pname = "cosmic-settings";
  version = "1.0.0-alpha.4-unstable-2024-12-11";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-settings";
    rev = "0072b79885f0c337e9ee5e6d296165f27c9fc3f4";
    hash = "sha256-bigj1slVQOtppWEy58TAu4o3V5dBMLLfPbDg6brwqLo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "accesskit-0.16.0" = "sha256-yeBzocXxuvHmuPGMRebbsYSKSvN+8sUsmaSKlQDpW4w=";
      "accounts-zbus-0.1.0" = "sha256-9Pq5WFBeIRvP2VZaa3BzoqiQmzN6taa20u7k+2aF3v0=";
      "atomicwrites-0.4.2" = "sha256-QZSuGPrJXh+svMeFWqAXoqZQxLq/WfIiamqvjJNVhxA=";
      "clipboard_macos-0.1.0" = "sha256-tovB4fjPVVRY8LKn5albMzskFQ+1W5ul4jT5RXx9gKE=";
      "cosmic-bg-config-0.1.0" = "sha256-bmcMZIURozlptsR4si62NTmexqaCX1Yj5bYj49GDehQ=";
      "cosmic-client-toolkit-0.1.0" = "sha256-/DJ/PfqnZHB6VeRi7HXWp0Vruk+jWBe+VCLPpiJeEv4=";
      "cosmic-comp-config-0.1.0" = "sha256-v4/ThL21gkrLqHx6chQWaXSCEuh5UvybAp17cDWSQoA=";
      "cosmic-config-0.1.0" = "sha256-U6zDb+hqI5HY0XjTMwwe5/qTUyKaqjteUdyPWquMXKw=";
      "cosmic-freedesktop-icons-0.2.6" = "sha256-+GvdoGHlTzu3joGkX89c+4lsc/l6FkbAqN4TD9IO8t8=";
      "cosmic-idle-config-0.1.0" = "sha256-+BOzbFDEoIaYkXs48RJtfomv8qdzIFiEpDpN/zDDgFM=";
      "cosmic-panel-config-0.1.0" = "sha256-tMOB4ucdBPl/PjU04Za8UCHPgiVW5TPkqWyQbDyhzWk=";
      "cosmic-randr-0.1.0" = "sha256-H7b1y7tujXvaD7E/3nIRAfp2nErASiIxvA1qnYCikt8=";
      "cosmic-settings-config-0.1.0" = "sha256-wwrbZJ/FA6qjeo9M/gIlzVyygiLT3R5OTLhTwr/QSSw=";
      "cosmic-settings-subscriptions-0.1.0" = "sha256-fCWGXR+Ky5W/D46OvZX7VyrmOjlxliZCHgsvPS6MgXY=";
      "cosmic-text-0.12.1" = "sha256-nCw3RNIHINXH4+m9wKB+0CeoXSVKKxP+ylaZhfp8u+o=";
      "dpi-0.1.1" = "sha256-whi05/2vc3s5eAJTZ9TzVfGQ/EnfPr0S4PZZmbiYio0=";
      "fast_image_resize-5.0.0" = "sha256-EQBjJlPfoPEFqEYf840jAUfHsGABbsGlGgJ+qwv68Ds=";
      "iced_glyphon-0.6.0" = "sha256-u1vnsOjP8npQ57NNSikotuHxpi4Mp/rV9038vAgCsfQ=";
      "smithay-clipboard-0.8.0" = "sha256-4InFXm0ahrqFrtNLeqIuE3yeOpxKZJZx+Bc0yQDtv34=";
      "softbuffer-0.4.1" = "sha256-a0bUFz6O8CWRweNt/OxTvflnPYwO5nm6vsyc/WcXyNg=";
      "superblock-0.1.0" = "sha256-AjK2pDMZTEavJb5hM+DMMTxD5rhSvtHkiXFH4kKEZrM=";
      "system-0.1.0" = "sha256-2/PSh1Ups/xyZm6T8+Qfc0lcdD/xEuitwnPPmGTlJ5M=";
      "taffy-0.3.11" = "sha256-SCx9GEIJjWdoNVyq+RZAGn0N71qraKZxf9ZWhvyzLaI=";
    };
  };

  nativeBuildInputs = [
    libcosmicAppHook'
    rustPlatform.bindgenHook
    cmake
    just
    pkg-config
    util-linux
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
    libinput
    pipewire
    pulseaudio
    udev
  ];

  dontUseJustBuild = true;
  dontUseJustCheck = true;

  justFlags = [
    "--set"
    "prefix"
    (placeholder "out")
    "--set"
    "bin-src"
    "target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/cosmic-settings"
  ];

  postInstall = ''
    libcosmicAppWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ cosmic-randr ]})
    libcosmicAppWrapperArgs+=(--set X11_BASE_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.xml)
    libcosmicAppWrapperArgs+=(--set X11_EXTRA_RULES_XML ${xkeyboard_config}/share/X11/xkb/rules/base.extras.xml)
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "epoch-(.*)"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/pop-os/cosmic-settings";
    description = "Settings for the COSMIC Desktop Environment";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      # lilyinstarlight
    ];
    platforms = platforms.linux;
    mainProgram = "cosmic-settings";
  };
}
