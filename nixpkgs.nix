let
  # Branch 'nixos-22.11', the same we use for our NixOS image
  rev = "db1e4eeb0f9a9028bcb920e00abbc1409dd3ef36";
  sha256 = "1yc6ms5n8kjlpqpb625j8z4qnx5cgdgfdrm64bsdzqb3lg61flwh";
  tarball = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256;
  };
in
builtins.trace "Using default Nixpkgs revision '${rev}'..." (import tarball)
