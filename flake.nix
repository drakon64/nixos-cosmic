# Modifications from https://github.com/lilyinstarlight/nixos-cosmic/issues/221

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    flake-compat = {
      url = "github:nix-community/flake-compat";
      flake = false;
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay, ... }: let
    forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];

    pkgsForSystem = system: import nixpkgs {
      inherit system;
      overlays = [
        rust-overlay.overlays.default
        self.overlays.default
      ];
    };

    makeCustomRustPlatform = system: pkgs: let
      latestStable = rust-overlay.packages.${system}.default;
    in pkgs.makeRustPlatform {
      cargo = latestStable;
      rustc = latestStable;
    };

  in {
    lib = {
      packagesFor = system: let
        pkgs = pkgsForSystem system;
        customRustPlatform = makeCustomRustPlatform system pkgs;
      in import ./pkgs {
        inherit pkgs customRustPlatform;
      };
    };

    packages = forAllSystems (system:
      self.lib.packagesFor system
    );

    overlays = {
      default = final: prev: let
        system = final.stdenv.hostPlatform.system;
        customRustPlatform = makeCustomRustPlatform system final;
      in import ./pkgs {
        pkgs = final;
        inherit customRustPlatform;
      };
    };

    nixosModules = {
      default = import ./nixos { cosmicOverlay = self.overlays.default; };
    };

    legacyPackages = forAllSystems (system: let
      pkgs = pkgsForSystem system;
    in {
      update = pkgs.writeShellApplication {
        name = "cosmic-update";

        runtimeInputs = [
          pkgs.coreutils
          pkgs.nix-update
        ];

        text = ''
          for pkg in pkgs/*; do
            if ! [ -f "$pkg/package.nix" ]; then
              continue
            fi

            attr="$(basename "$pkg")"

            if [ "$attr" = libcosmicAppHook ]; then
              continue
            fi

            nix-update --commit --version branch=HEAD "$attr"
          done
        '';
      };

      vm = nixpkgs.lib.makeOverridable ({ nixpkgs }: let
        nixosConfig = nixpkgs.lib.nixosSystem {
          modules = [
            ({ lib, pkgs, modulesPath, ... }: {
              imports = [
                self.nixosModules.default

                "${builtins.toString modulesPath}/virtualisation/qemu-vm.nix"
              ];

              services.desktopManager.cosmic.enable = true;
              services.displayManager.cosmic-greeter.enable = true;

              services.flatpak.enable = true;

              environment.systemPackages = [ pkgs.drm_info pkgs.firefox pkgs.cosmic-emoji-picker pkgs.cosmic-tasks ];

              boot.kernelParams = [ "quiet" "udev.log_level=3"  ];
              boot.initrd.kernelModules = [ "bochs" ];

              boot.initrd.verbose = false;

              boot.initrd.systemd.enable = true;

              boot.loader.systemd-boot.enable = true;
              boot.loader.timeout = 0;

              boot.plymouth.enable = true;
              boot.plymouth.theme = "nixos-bgrt";
              boot.plymouth.themePackages = [ pkgs.nixos-bgrt-plymouth ];

              services.openssh = {
                enable = true;
                settings.PermitRootLogin = "yes";
              };

              documentation.nixos.enable = false;

              users.mutableUsers = false;
              users.users.root.password = "meow";
              users.users.user = {
                isNormalUser = true;
                password = "meow";
              };

              virtualisation.useBootLoader = true;
              virtualisation.useEFIBoot = true;
              virtualisation.mountHostNixStore = true;

              virtualisation.memorySize = 4096;
              # TODO: below options can be removed once NixOS/nixpkgs#279009 is merged
              virtualisation.qemu.options = [ "-vga none" "-device virtio-gpu-gl-pci" "-display default,gl=on" ];

              virtualisation.forwardPorts = [
                { from = "host"; host.port = 2222; guest.port = 22; }
              ];

              nixpkgs.hostPlatform = system;

              system.stateVersion = lib.trivial.release;
            })
          ];
        };
      in nixosConfig.config.system.build.vm // { closure = nixosConfig.config.system.build.toplevel; inherit (nixosConfig) config pkgs; }) { inherit nixpkgs; };
    });
  };
}
