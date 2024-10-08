{
  # description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    flake-parts,
    devshell,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        devshell.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      perSystem = {pkgs, ...}: let
        runtimeInputs = with pkgs; [
          procps # provides pgrep
          xxHash # provides xxhsum
          gtk3 # provides gtk-launch
          libnotify # provides notify-send
        ];
      in {
        devshells.default = {
          env = [];
          commands = [];
          packages = runtimeInputs;
        };

        packages = {
          default = pkgs.writeShellApplication {
            name = "ww";
            inherit runtimeInputs;
            text = builtins.readFile ./ww;
          };
        };
      };
    };
}
