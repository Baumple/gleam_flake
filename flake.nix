{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }: 
  flake-utils.lib.eachDefaultSystem(system: 
  let 
    overlays = [ (import rust-overlay) (final: prev: {
      gleam = prev.gleam.overrideAttrs(oldAttrs: rec {
        src = prev.fetchFromGitHub {
          owner = "gleam-lang";
          repo = "gleam";
          rev = "refs/tags/v1.8.0";
          hash = "sha256-gBVr4kAec8hrDBiRXa/sQUNYvgSX3nTVMwFGYRFCbSA=";
        };
        cargoDeps = oldAttrs.cargoDeps.overrideAttrs (prev.lib.const {
          name = "gleam-lang-vendor.tar.gz";
          inherit src;
          outputHash = "sha256-r6Clv/++CqGlWf5qv2yn4NJ0yTRF2X7XdiJChQFFEpw=";
        });
      });
    }) ];

    rust = pkgs.rust-bin.beta.latest.default.override {
      extensions = [
        "rust-src"
        "rust-analyzer"
      ];
    };
    pkgs = import nixpkgs {
      inherit system overlays;
    };
  in
  {
    devShells.default = with pkgs; mkShell {
      buildInputs = [
        rust
        gleam
        inotify-tools
        erlang_27
        mermaid-cli
      ];
    };
  });
}
